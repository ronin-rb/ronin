#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ronin/exceptions/duplicate_overlay'
require 'ronin/exceptions/overlay_not_found'
require 'ronin/model/has_license'
require 'ronin/model/has_authors'
require 'ronin/model'
require 'ronin/cached_file'
require 'ronin/config'

require 'pullr'
require 'data_paths'
require 'yaml'

module Ronin
  class Overlay

    include Model
    include Model::HasLicense
    include Model::HasAuthors
    include DataPaths

    # The default domain that overlays are added from
    LOCAL_DOMAIN = 'localhost'

    # Overlay metadata file name
    METADATA_FILE = 'overlay.yml'

    # Overlay bin/ directory
    LIB_DIR = 'bin'

    # Overlay lib/ directory
    LIB_DIR = 'lib'

    # The init.rb file to load from the LIB_DIR
    INIT_FILE = 'init.rb'

    # Overlay `data/` directory
    DATA_DIR = 'data'

    # Overlay cache/ directory
    CACHE_DIR = 'cache'

    # The primary key of the overlay
    property :id, Serial

    # The SCM used by the overlay repository
    property :scm, String

    # Local path to the overlay repository
    property :path, FilePath, :required => true, :unique => true

    # URI that the overlay was installed from
    property :uri, URI

    # Specifies whether the overlay was installed remotely
    # or added using a local directory.
    property :installed, Boolean, :default => false

    # Name of the overlay
    property :name, String, :default => lambda { |overlay,name|
      overlay.path.basename
    }

    # The domain the overlay belongs to
    property :domain, String, :required => true

    # Title of the overlay
    property :title, Text

    # Source View URI of the overlay
    property :source, URI

    # Website URI for the overlay
    property :website, URI

    # Description
    property :description, Text

    # The cached files from the overlay
    has 0..n, :cached_files

    # Ruby Gems required by the overlay
    attr_reader :gems

    # The lib directory
    attr_reader :bin_dir

    # The lib directory
    attr_reader :lib_dir

    # The data directory
    attr_reader :data_dir

    # The cache directory
    attr_reader :cache_dir

    #
    # Creates a new Overlay object.
    #
    # @param [Hash] attributes
    #   The attributes of the overlay.
    #
    # @param [String] path
    #   The path to the overlay.
    #
    # @param [Symbol] scm
    #   The SCM used by the overlay. Can be either `:git`, `:mercurial`,
    #   `:sub_version` or `:rsync`.
    #
    # @param [String, URI::HTTP, URI::HTTPS] uri
    #   The URI the overlay resides at.
    #
    # @yield [overlay]
    #   If a block is given, the overlay will be passed to it.
    #
    # @yieldparam [Overlay] overlay
    #   The newly created overlay.
    #
    def initialize(attributes={})
      super(attributes)

      @bin_dir = self.path.join(BIN_DIR)
      @lib_dir = self.path.join(LIB_DIR)
      @data_dir = self.path.join(DATA_DIR)
      @cache_dir = self.path.join(CACHE_DIR)

      @activated = false

      initialize_metadata

      yield self if block_given?
    end

    #
    # Searches for the Overlay with a given name, and potentially
    # installed from the given domain.
    #
    # @param [String] name
    #   The name of the Overlay.
    #
    # @return [Overlay]
    #   The found Overlay.
    #
    # @raise [OverlayNotFound]
    #   No Overlay could be found with the given name or domain.
    #
    # @example Load the Overlay with the given name
    #   Overlay.find('postmodern-overlay')
    #
    # @example Load the Overlay with the given name and domain.
    #   Overlay.find('postmodern-overlay/github.com')
    #
    # @since 1.0.0
    #
    def Overlay.find(name)
      name, domain = name.to_s.split('/',2)

      query = {:name => name}
      query[:domain] = domain if domain

      unless (overlay = Overlay.first(query))
        if domain
          raise(OverlayNotFound,"overlay #{name.dump} from domain #{domain.dump} cannot be found")
        else
          raise(OverlayNotFound,"overlay #{name.dump} cannot be found")
        end
      end

      return overlay
    end

    #
    # Adds an Overlay with the given options.
    #
    # @return [Overlay]
    #   The added Overlay.
    #
    # @raise [ArgumentError]
    #   The `:path` option was not specified.
    #
    # @raise [OverlayNotFound]
    #   The path of the Overlay did not exist or was not a directory.
    #
    # @raise [DuplicateOverlay]
    #   The Overlay was already added or installed.
    #
    # @since 1.0.0
    #
    def Overlay.add!(options={})
      unless options.has_key?(:path)
        raise(ArgumentError,"the :path option was not given")
      end

      path = Pathname.new(options[:path]).expand_path

      unless path.directory?
        raise(OverlayNotFound,"overlay #{path} cannot be found")
      end

      if Overlay.count(:path => path) > 0
        raise(DuplicateOverlay,"an overlay at the path #{path} was already added")
      end

      # create the Overlay
      overlay = Overlay.new(options.merge(
        :path => path,
        :installed => false,
        :domain => LOCAL_DOMAIN
      ))

      name = overlay.name
      domain = overlay.domain

      if Overlay.count(:name => name, :domain => domain) > 0
        raise(DuplicateOverlay,"the overlay #{overlay} already exists in the database")
      end

      # save the Overlay
      if overlay.save
        # cache any files from within the `cache/` directory of the
        # overlay
        overlay.cache_files!
      end

      return overlay
    end

    #
    # Installs an overlay into the OverlayCache::CACHE_DIR and adds it
    # to the overlay cache.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Addressable::URI, String] :uri
    #   The URI to the Overlay.
    #
    # @option options [Symbol] :scm
    #   The SCM used by the Overlay. May be either `:git`, `:mercurial`,
    #   `:sub_version` or `:rsync`.
    #
    # @return [Overlay]
    #   The newly installed Overlay.
    #
    # @raise [ArgumentError]
    #   The `:uri` option must be specified.
    #
    # @raise [DuplicateOverlay]
    #   An Overlay already exists with the same `name` and `host`
    #   properties.
    #
    # @since 1.0.0
    #
    def Overlay.install!(options={})
      unless options[:uri]
        raise(ArgumentError,":uri must be passed to Overlay.install")
      end

      repo = Pullr::RemoteRepository.new(options)
      name = repo.name
      domain = if repo.uri.scheme
                 repo.uri.host
               else
                 # Use a regexp to pull out the host-name, if the URI
                 # lacks a scheme.
                 repo.uri.to_s.match(/\@([^@:\/]+)/)[1]
               end

      if Overlay.count(:name => name, :domain => domain) > 0
        raise(DuplicateOverlay,"an Overlay already exists with the name #{name.dump} from domain #{domain.dump}")
      end

      path = File.join(Config::CACHE_DIR,name,domain)

      # pull down the remote repository
      local_repo = repo.pull(path)

      # add the new remote overlay
      overlay = Overlay.new(
        :path => path,
        :scm => local_repo.scm,
        :uri => repo.uri,
        :installed => true,
        :name => name,
        :domain => domain
      )

      # save the Overlay
      if overlay.save
        # cache any files from within the `cache/` directory of the
        # overlay
        overlay.cache_files!
      end

      return overlay
    end

    #
    # Updates all Overlays.
    #
    # @yield [overlay]
    #   If a block is given, it will be passed each updated Overlay.
    #
    # @yieldparam [Overlay] overlay
    #   An updated Overlay.
    #
    # @since 1.0.0
    #
    def Overlay.update!
      Overlay.each do |overlay|
        # update the overlay's contents
        overlay.update!

        yield overlay if block_given?
      end
    end

    #
    # Uninstalls the Overlay with the given name or domain.
    #
    # @param [String] name
    #   The name of the Overlay to uninstall.
    #
    # @return [nil]
    #
    # @example Uninstall the Overlay with the given name
    #   Overlay.uninstall!('postmodern-overlay')
    #
    # @example Uninstall the Overlay with the given name and domain.
    #   Overlay.uninstall!('postmodern-overlay/github.com')
    #
    def Overlay.uninstall!(name)
      Overlay.find(name).uninstall!
    end

    #
    # Activates all installed or added overlays.
    #
    # @return [Array<Overlay>]
    #   The activated overlays.
    #
    # @see #activate!
    #
    # @since 1.0.0
    #
    def Overlay.activate!
      Overlay.each { |overlay| overlay.activate! }
    end

    #
    # De-activates all installed or added overlays.
    #
    # @return [Array<Overlay>]
    #   The de-activated overlays.
    #
    # @see #deactivate!
    #
    # @since 1.0.0
    #
    def Overlay.deactivate!
      Overlay.all.reverse_each { |overlay| overlay.deactivate! }
    end

    #
    # Determines if the overlay was added locally.
    #
    # @return [Boolean]
    #   Specifies whether the overlay was added locally.
    #
    # @since 1.0.0
    #
    def local?
      self.domain == LOCAL_DOMAIN
    end

    #
    # Determines if the overlay was installed from a remote repository.
    #
    # @return [Boolean]
    #   Specifies whether the overlay was installed from a remote
    #   repository.
    #
    # @since 1.0.0
    #
    def remote?
      self.domain != LOCAL_DOMAIN
    end

    #
    # All paths within the `cache/` directory of the overlay.
    #
    # @return [Array<Pathname>]
    #   The paths within the `cache/` directory.
    #
    # @since 1.0.0
    #
    def cache_paths
      Pathname.glob(@cache_dir.join('**','*.rb'))
    end

    #
    # Determines if the overlay has been activated.
    #
    # @return [Boolean]
    #   Specifies whether the overlay has been activated.
    #
    def activated?
      @activated == true
    end

    #
    # Activates the overlay by adding the {#lib_dir} to the `$LOAD_PATH`
    # global variable.
    #
    def activate!
      # add the data/ directory
      register_data_dir(@data_dir) if File.directory?(@data_dir)

      if File.directory?(@lib_dir)
        $LOAD_PATH << @lib_dir unless $LOAD_PATH.include?(@lib_dir)
      end

      # load the lib/init.rb file
      init_path = self.path.join(LIB_DIR,INIT_FILE)
      load init_path if init_path.file?

      @activated = true
      return true
    end

    #
    # De-activates the overlay by removing the {#lib_dir} from the
    # `$LOAD_PATH` global variable.
    #
    def deactivate!
      unregister_data_dirs!

      $LOAD_PATH.delete(@lib_dir)

      @activated = false
      return true
    end

    #
    # Clears the {#cached_files} and re-saves the cached files within the
    # `cache/` directory.
    #
    # @return [Overlay]
    #   The cleaned overlay.
    #
    # @since 1.0.0
    #
    def cache_files!
      clean_cached_files!

      cache_paths.each do |path|
        self.cached_files.new(:path => path).cache
      end

      return self
    end

    #
    # Syncs the {#cached_files} of the overlay, and adds any new cached
    # files.
    #
    # @return [Overlay]
    #   The cleaned overlay.
    #
    # @since 1.0.0
    #
    def sync_cached_files!
      # activates the overlay before caching it's objects
      activate!

      new_paths = cache_paths

      self.cached_files.each do |cached_file|
        # filter out pre-existing paths within the `cached/` directory
        new_paths.delete(cached_file.path)

        # sync the cached file and catch any exceptions
        cached_file.sync
      end

      # cache the new paths within the `cache/` directory
      new_paths.each do |path|
        self.cached_files.new(:path => path).cache
      end

      # deactivates the overlay
      deactivate!

      return self
    end

    #
    # Deletes any {#cached_files} associated with the overlay.
    #
    # @return [Overlay]
    #   The cleaned overlay.
    #
    # @since 1.0.0
    #
    def clean_cached_files!
      self.cached_files.clear
      return self
    end

    #
    # Updates the overlay, reloads it's metadata and syncs the
    # cached files of the overlay.
    #
    # @yield [overlay]
    #   If a block is given, it will be passed after the overlay has
    #   been updated.
    #
    # @yieldparam [Overlay] overlay
    #   The updated overlay.
    #
    # @return [Overlay]
    #   The updated overlay.
    #
    # @since 1.0.0
    #
    def update!
      local_repo = Pullr::LocalRepository.new(
        :path => self.path,
        :scm => self.scm
      )

      # only update if we have a repository
      local_repo.update(self.uri)

      # re-initialize the metadata
      initialize_metadata()

      # save the overlay
      if save
        # syncs the cached files of the overlay
        sync_cached_files!
      end

      yield self if block_given?
      return self
    end

    #
    # Deletes the contents of the overlay.
    #
    # @yield [overlay]
    #   If a block is given, it will be passed the overlay after it's
    #   contents have been deleted.
    #
    # @yieldparam [Overlay] overlay
    #   The deleted overlay.
    #
    # @return [Overlay]
    #   The deleted overlay.
    #
    # @since 1.0.0
    #
    def uninstall!
      deactivate!

      FileUtils.rm_rf(self.path) if self.installed?

      # destroy any cached files first
      clean_cached_files!

      # remove the overlay from the database
      destroy if saved?

      yield self if block_given?
      return self
    end

    #
    # @return [String]
    #   The name of the overlay.
    #
    def to_s
      "#{self.name}/#{self.domain}"
    end

    #
    # Loads the overlay metadata from the METADATA_FILE within the
    # overlay.
    #
    def initialize_metadata
      metadata_path = self.path.join(METADATA_FILE)

      self.title = self.name
      self.description = nil
      self.license = nil

      self.source = self.uri
      self.website = self.source
      self.authors.clear

      if File.file?(metadata_path)
        metadata = YAML.load_file(metadata_path)

        if (title = metadata['title'])
          self.title = title
        end

        if (description = metadata['description'])
          self.description = description
        end

        if (license = metadata['license'])
          self.license = License.predefined_resource_with(:name => license)
        end

        if (uri = metadata['uri'])
          self.uri ||= uri
        end

        if (source = metadata['source'])
          self.source = source
        end

        if (website = metadata['website'])
          self.website = website
        end

        case metadata['authors']
        when Hash
          metadata['authors'].each do |name,email|
            self.authors << Author.first_or_new(
              :name => name,
              :email => email
            )
          end
        when Array
          metadata['authors'].each do |name|
            self.authors << Author.first_or_new(:name => name)
          end
        when String
          self.authors << Author.first_or_new(
            :name => metadata['authors']
          )
        end
      end

      return self
    end

  end
end

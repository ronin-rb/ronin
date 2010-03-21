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

require 'ronin/platform/exceptions/overlay_not_found'
require 'ronin/platform/exceptions/extension_not_found'
require 'ronin/platform/maintainer'
require 'ronin/platform/object_cache'
require 'ronin/platform/extension'
require 'ronin/platform/config'
require 'ronin/model/has_license'
require 'ronin/model'

require 'pullr'
require 'static_paths'
require 'nokogiri'

module Ronin
  module Platform
    class Overlay

      include Model
      include Model::HasLicense
      include StaticPaths

      # Overlay Implementation Version
      VERSION = 2

      # A list of compatible Overlay Implementation Versions
      COMPATIBLE_VERSIONS = [1,2]

      # The default host-name that overlays are installed from
      DEFAULT_HOST = 'localhost'

      # Overlay metadata XML file name
      METADATA_FILE = 'ronin.xml'

      # Overlay lib/ directory
      LIB_DIR = 'lib'

      # The init.rb file to load from the LIB_DIR
      INIT_FILE = 'init.rb'

      # Overlay static/ directory
      STATIC_DIR = 'static'

      # Overlay cache/ directory
      CACHE_DIR = 'cache'

      # Overlay exts/ directory
      EXTS_DIR = 'exts'

      # The primary key of the overlay
      property :id, Serial

      # The SCM used by the overlay repository
      property :scm, String

      # Local path to the overlay repository
      property :path, String, :required => true, :unique => true

      # URI that the overlay was installed from
      property :uri, URI

      # Specifies whether the overlay was installed remotely
      # or added using a local directory.
      property :installed, Boolean, :default => false

      # The format version of the overlay
      property :version, Integer, :required => true

      # The host the overlay belongs to
      property :host, String, :default => lambda { |overlay,host|
        if overlay.uri
          overlay.uri.host
        else
          DEFAULT_HOST
        end
      }

      # Name of the overlay
      property :name, String, :default => lambda { |overlay,name|
        File.basename(overlay.path)
      }

      # Title of the overlay
      property :title, Text

      # Source View URI of the overlay
      property :source, String

      # Website URI for the overlay
      property :website, String

      # Description
      property :description, Text

      # Maintainers of the overlay
      has 0..n, :maintainers

      # Ruby Gems required by the overlay
      attr_reader :gems

      # The lib directory
      attr_reader :lib_dir

      # The static directory
      attr_reader :static_dir

      # The cache directory
      attr_reader :cache_dir

      # The exts directory
      attr_reader :exts_dir

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
      def initialize(attributes={},&block)
        super(attributes)

        @lib_dir = File.join(self.path,LIB_DIR)
        @static_dir = File.join(self.path,STATIC_DIR)
        @cache_dir = File.join(self.path,CACHE_DIR)
        @exts_dir = File.join(self.path,EXTS_DIR)

        begin
          @repository = Pullr::LocalRepository.new(
            :path => self.path,
            :scm => self.scm
          )

          self.scm ||= @repository.scm
        rescue Pullr::AmbigiousRepository
        end

        @activated = false

        initialize_metadata()

        block.call(self) if block
      end

      #
      # Searches for the Overlay with a given name, and potentially
      # installed from the given host.
      #
      # @param [String] name
      #   The name of the Overlay.
      #
      # @return [Overlay]
      #   The found Overlay.
      #
      # @raise [OverlayNotFound]
      #   No Overlay could be found with the given name or host.
      #
      # @example Load the Overlay with the given name
      #   Overlay.get('postmodern-overlay')
      #
      # @example Load the Overlay with the given name and host.
      #   Overlay.get('postmodern-overlay/github.com')
      #
      # @since 0.4.0
      #
      def Overlay.get(name)
        name, host = name.to_s.split('/',2)

        query = {:name => name}
        query[:host] = host if host

        unless (overlay = Overlay.first(query))
          if host
            raise(OverlayNotFound,"Overlay #{name.dump} from host #{host.dump} cannot be found",caller)
          else
            raise(OverlayNotFound,"Overlay #{name.dump} cannot be found",caller)
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
      # @raise [OverlayCached]
      #   The Overlay was already added or installed.
      #
      # @since 0.4.0
      #
      def Overlay.add!(options={})
        unless options.has_key?(:path)
          raise(ArgumentError,"The :path option was not given",caller)
        end

        path = File.expand_path(options[:path].to_s)

        unless File.directory?(path)
          raise(OverlayNotFound,"Overlay #{path.dump} cannot be found",caller)
        end

        if Overlay.count(:path => path) > 0
          raise(OverlayCached,"An overlay at the path #{path.dump} was already added",caller)
        end

        # create the Overlay
        overlay = Overlay.new(options.merge(:path => path))

        if Overlay.count(:name => overlay.name, :host => overlay.host) > 0
          raise(OverlayCached,"The overlay #{overlay} already exists in the database",caller)
        end

        # save the Overlay
        overlay.save!

        # update the object cache
        ObjectCache.cache(overlay.cache_dir)

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
      # @raise [OverlayCached]
      #   An Overlay already exists with the same `name` and `host`
      #   properties.
      #
      # @since 0.4.0
      #
      def Overlay.install!(options={})
        unless options[:uri]
          raise(ArgumentError,":uri must be passed to Platform.install",caller)
        end

        repo = Pullr::RemoteRepository.new(options)
        name = repo.name
        host = repo.uri.host

        if Overlay.count(:name => name, :host => host) > 0
          raise(OverlayCached,"An Overlay already exists with the name #{name.dump} from host #{host.dump}",caller)
        end

        path = File.join(Config::CACHE_DIR,name,host)

        # pull down the remote repository
        repo.pull(path)

        # add the new remote overlay
        return Overlay.add!(
          :path => path,
          :uri => repo.uri,
          :installed => true,
          :host => host,
          :name => name
        )
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
      # @since 0.4.0
      #
      def Overlay.update!(&block)
        Overlay.all.each do |overlay|
          # update the overlay's contents
          overlay.update!

          block.call(overlay) if block
        end
      end

      #
      # Uninstalls the Overlay with the given name or host.
      #
      # @param [String] name
      #   The name of the Overlay to uninstall.
      #
      # @param [String] host
      #   The host the Overlay was installed from.
      #
      # @return [nil]
      #
      # @example Uninstall the Overlay with the given name
      #   Overlay.uninstall!('postmodern-overlay')
      #
      # @example Uninstall the Overlay with the given name and host.
      #   Overlay.uninstall!('postmodern-overlay/github.com')
      #
      def Overlay.uninstall!(name)
        Overlay.get(name).uninstall!
      end

      #
      # Determines if the overlay's implementation version is compatible
      # with the current implementation of {Overlay}.
      #
      # @return [Boolean]
      #   Specifies whether the overlay is still compatible with the
      #   {Platform}.
      #
      def compatible?
        COMPATIBLE_VERSIONS.each do |compat|
          return true if compat === self.version
        end

        return false
      end

      #
      # @return [Array]
      #   The paths of all extensions within the overlay.
      #
      def extension_paths
        Dir[File.join(@exts_dir,'*.rb')]
      end

      #
      # @return [Array]
      #   The names of all extensions within the overlay.
      #
      def extensions
        extension_paths.map { |dir| File.basename(dir).gsub(/\.rb$/,'') }
      end

      #
      # Searches for the extension with the specified name within the
      # overlay.
      #
      # @param [String, Symbol] name
      #   The name of the extension to search for.
      #
      # @return [Boolean]
      #   Specifies whether the overlay contains the extension with the
      #   specified name.
      #
      def has_extension?(name)
        extensions.include?(name.to_s)
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
        # add the static/ directory
        register_static_dir(@static_dir) if File.directory?(@static_dir)

        if File.directory?(@lib_dir)
          $LOAD_PATH << @lib_dir unless $LOAD_PATH.include?(@lib_dir)
        end

        # load the lib/init.rb file
        init_path = File.join(self.path,LIB_DIR,INIT_FILE)
        load init_path if File.file?(init_path)

        @activated = true
        return true
      end

      #
      # Deactivates the overlay by removing the {#lib_dir} from the
      # `$LOAD_PATH` global variable.
      #
      def deactivate!
        unregister_static_dirs!

        $LOAD_PATH.delete(@lib_dir)

        @activated = false
        return true
      end

      #
      # Updates the overlay, reloads it's metadata and syncs the
      # ObjectCache.
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
      # @since 0.4.0
      #
      def update!(&block)
        # only update if we have a repository
        @repository.update(self.uri) if @repository

        # re-initialize the metadata
        initialize_metadata()

        # save the overlay
        save!

        # activates the overlay before caching it's objects
        activate!

        # sync the object cache
        ObjectCache.sync(@cache_dir)

        # deactivates the overlay
        deactivate!

        block.call(self) if block
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
      # @since 0.4.0
      #
      def uninstall!(&block)
        deactivate!

        FileUtils.rm_rf(self.path) if self.installed?

        # clean the object cache
        ObjectCache.clean(@cache_dir)

        # remove the overlay from the database
        destroy if saved?

        block.call(self) if block
        return self
      end

      #
      # @return [String]
      #   The name of the overlay.
      #
      def to_s
        "#{self.name}/#{self.host}"
      end

      #
      # Loads the overlay metadata from the METADATA_FILE within the
      # overlay.
      #
      def initialize_metadata()
        metadata_path = File.join(self.path,METADATA_FILE)

        self.version = 0

        self.title = self.name
        self.description = nil
        self.license = nil

        self.source = self.uri
        self.website = self.source
        self.maintainers.clear

        @gems = []

        if File.file?(metadata_path)
          doc = Nokogiri::XML(open(metadata_path))
          overlay = doc.at('/ronin-overlay')

          if (version_attr = overlay.attributes['version'])
            self.version = version_attr.inner_text.strip.to_i
          end

          if (title_tag = overlay.at('title'))
            self.title = title_tag.inner_text.strip
          end

          if (description_tag = overlay.at('description'))
            self.description = description_tag.inner_text.strip
          end

          if (license_tag = overlay.at('license'))
            name = license_tag.inner_text.strip

            self.license = License.predefined_resource_with(:name => name)
          end

          if (uri_tag = overlay.at('uri'))
            self.uri ||= uri_tag.inner_text.strip
          end

          if (source_tag = overlay.at('source'))
            self.source = source_tag.inner_text.strip
          end

          if (website_tag = overlay.at('website'))
            self.website = website_tag.inner_text.strip
          end

          overlay.search('maintainers/maintainer').each do |maintainer|
            if (name = maintainer.at('name'))
              name = name.inner_text.strip
            end

            if (email = maintainer.at('email'))
              email = email.inner_text.strip
            end

            self.maintainers << Maintainer.first_or_new(
              :name => name,
              :email => email
            )
          end

          overlay.search('dependencies/gem').each do |gem|
            @gems << gem.inner_text.strip
          end
        end

        return self
      end

    end
  end
end

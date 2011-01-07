#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/exceptions/duplicate_repository'
require 'ronin/exceptions/repository_not_found'
require 'ronin/cached_file'
require 'ronin/model/has_license'
require 'ronin/model/has_authors'
require 'ronin/model'
require 'ronin/config'

require 'pullr'
require 'data_paths'
require 'yaml'

module Ronin
  class Repository

    include Model
    include Model::HasAuthors
    include Model::HasLicense
    include DataPaths

    # The default domain that repositories are added from
    LOCAL_DOMAIN = 'localhost'

    # Repository metadata file name
    METADATA_FILE = 'ronin.yml'

    # Repository `bin/` directory
    BIN_DIR = 'bin'

    # Repository `lib/` directory
    LIB_DIR = 'lib'

    # The `init.rb` file to load from the {LIB_DIR}
    INIT_FILE = 'init.rb'

    # Repository `data/` directory
    DATA_DIR = 'data'

    # Repository `cache/` directory
    CACHE_DIR = 'cache'

    # The primary key of the repository
    property :id, Serial

    # The SCM used by the repository
    property :scm, String

    # Local path to the repository
    property :path, FilePath, :required => true, :unique => true

    # URI that the repository was installed from
    property :uri, URI

    # Specifies whether the repository was installed remotely
    # or added using a local directory.
    property :installed, Boolean, :default => false

    # Name of the repository
    property :name, String, :default => lambda { |repo,name|
      repo.path.basename
    }

    # The domain the repository belongs to
    property :domain, String, :required => true

    # Title of the repository
    property :title, Text

    # Source View URI of the repository
    property :source, URI

    # Website URI for the repository
    property :website, URI

    # Description of the repository
    property :description, Text

    # The cached files from the repository
    has 0..n, :cached_files

    # The `bin/` directory
    attr_reader :bin_dir

    # The `lib/` directory
    attr_reader :lib_dir

    # The `data/` directory
    attr_reader :data_dir

    # The `cache/` directory
    attr_reader :cache_dir

    #
    # Creates a new {Repository} object.
    #
    # @param [Hash] attributes
    #   The attributes of the repository.
    #
    # @param [String] path
    #   The path to the repository.
    #
    # @param [Symbol] scm
    #   The SCM used by the repository. Can be either `:git`, `:mercurial`,
    #   `:sub_version` or `:rsync`.
    #
    # @param [String, URI::HTTP, URI::HTTPS] uri
    #   The URI the repository resides at.
    #
    # @yield [repo]
    #   If a block is given, the repository will be passed to it.
    #
    # @yieldparam [Repository] repo
    #   The newly created repository.
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
    # Searches for the Repository with a given name, and potentially
    # installed from the given domain.
    #
    # @param [String] name
    #   The name of the repository.
    #
    # @return [Repository]
    #   The matching repository.
    #
    # @raise [RepositoryNotFound]
    #   No repository could be found with the given name or domain.
    #
    # @example Load the repository with the given name
    #   Repository.find('postmodern-repo')
    #
    # @example Load the repository with the given name and domain.
    #   Repository.find('postmodern-repo/github.com')
    #
    # @since 1.0.0
    #
    def Repository.find(name)
      name, domain = name.to_s.split('/',2)

      query = {:name => name}
      query[:domain] = domain if domain

      unless (repo = Repository.first(query))
        if domain
          raise(RepositoryNotFound,"Repository #{name.dump} from domain #{domain.dump} cannot be found")
        else
          raise(RepositoryNotFound,"Repository #{name.dump} cannot be found")
        end
      end

      return repo
    end

    #
    # Adds an Repository with the given options.
    #
    # @return [Repository]
    #   The added repository.
    #
    # @raise [ArgumentError]
    #   The `:path` option was not specified.
    #
    # @raise [RepositoryNotFound]
    #   The path of the repository did not exist or was not a directory.
    #
    # @raise [DuplicateRepository]
    #   The repository was already added or installed.
    #
    # @since 1.0.0
    #
    def Repository.add!(options={})
      unless options.has_key?(:path)
        raise(ArgumentError,"the :path option was not given")
      end

      path = Pathname.new(options[:path]).expand_path

      unless path.directory?
        raise(RepositoryNotFound,"Repository #{path} cannot be found")
      end

      if Repository.count(:path => path) > 0
        raise(DuplicateRepository,"a Repository at the path #{path} was already added")
      end

      # create the repository
      repo = Repository.new(options.merge(
        :path => path,
        :installed => false,
        :domain => LOCAL_DOMAIN
      ))

      if Repository.count(:name => repo.name, :domain => repo.domain) > 0
        raise(DuplicateRepository,"the Repository #{repo} already exists in the database")
      end

      # save the repository
      if repo.save
        # cache any files from within the `cache/` directory of the
        # repository
        repo.cache_files!
      end

      return repo
    end

    #
    # Installs an repository.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Addressable::URI, String] :uri
    #   The URI to the repository.
    #
    # @option options [Symbol] :scm
    #   The SCM used by the repository. May be either `:git`, `:mercurial`,
    #   `:sub_version` or `:rsync`.
    #
    # @return [Repository]
    #   The newly installed repository.
    #
    # @raise [ArgumentError]
    #   The `:uri` option must be specified.
    #
    # @raise [DuplicateRepository]
    #   An repository already exists with the same `name` and `host`
    #   properties.
    #
    # @since 1.0.0
    #
    def Repository.install!(options={})
      unless options[:uri]
        raise(ArgumentError,":uri must be passed to Repository.install")
      end

      remote_repo = Pullr::RemoteRepository.new(options)
      name = remote_repo.name
      domain = if remote_repo.uri.scheme
                 remote_repo.uri.host
               else
                 # Use a regexp to pull out the host-name, if the URI
                 # lacks a scheme.
                 remote_repo.uri.to_s.match(/\@([^@:\/]+)/)[1]
               end

      if Repository.count(:name => name, :domain => domain) > 0
        raise(DuplicateRepository,"a Repository already exists with the name #{name.dump} from domain #{domain.dump}")
      end

      path = File.join(Config::REPOS_DIR,name,domain)

      # pull down the remote repository
      local_repo = remote_repo.pull(path)

      # add the new remote repository
      repo = Repository.new(
        :path => path,
        :scm => local_repo.scm,
        :uri => remote_repo.uri,
        :installed => true,
        :name => name,
        :domain => domain
      )

      # save the repository 
      if repo.save
        # cache any files from within the `cache/` directory of the
        # repository
        repo.cache_files!
      end

      return repo
    end

    #
    # Updates all repositories.
    #
    # @yield [repo]
    #   If a block is given, it will be passed each updated repository.
    #
    # @yieldparam [Repository] repo
    #   An updated repository.
    #
    # @since 1.0.0
    #
    def Repository.update!
      Repository.each do |repo|
        # update the repositories contents
        repo.update!

        yield repo if block_given?
      end
    end

    #
    # Uninstalls the repository with the given name or domain.
    #
    # @param [String] name
    #   The name of the repository to uninstall.
    #
    # @return [nil]
    #
    # @example Uninstall the repository with the given name
    #   Repository.uninstall!('postmodern-repo')
    #
    # @example Uninstall the repository with the given name and domain.
    #   Repository.uninstall!('postmodern-repo/github.com')
    #
    def Repository.uninstall!(name)
      Repository.find(name).uninstall!
    end

    #
    # Activates all installed or added repositories.
    #
    # @return [Array<Repository>]
    #   The activated repository.
    #
    # @see #activate!
    #
    # @since 1.0.0
    #
    def Repository.activate!
      Repository.each { |repo| repo.activate! }
    end

    #
    # De-activates all installed or added repositories.
    #
    # @return [Array<Repository>]
    #   The de-activated repositories.
    #
    # @see #deactivate!
    #
    # @since 1.0.0
    #
    def Repository.deactivate!
      Repository.reverse_each { |repo| repo.deactivate! }
    end

    #
    # Determines if the repository was added locally.
    #
    # @return [Boolean]
    #   Specifies whether the repository was added locally.
    #
    # @since 1.0.0
    #
    def local?
      self.domain == LOCAL_DOMAIN
    end

    #
    # Determines if the repository was installed remotely.
    #
    # @return [Boolean]
    #   Specifies whether the repository was installed from a remote URI.
    #
    # @since 1.0.0
    #
    def remote?
      self.domain != LOCAL_DOMAIN
    end

    #
    # The executable scripts in the `bin/` directory.
    #
    # @return [Array<String>]
    #   The executable script names.
    #
    # @since 1.0.0
    #
    def executables
      scripts = []

      if @bin_dir.directory?
        @bin_dir.entries.each do |path|
          scripts << path.basename.to_s if path.file?
        end
      end

      return scripts
    end

    #
    # All paths within the `cache/` directory of the repository.
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
    # Determines if the repository has been activated.
    #
    # @return [Boolean]
    #   Specifies whether the repository has been activated.
    #
    def activated?
      @activated == true
    end

    #
    # Activates the repository by adding the {#lib_dir} to the `$LOAD_PATH`
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
      require init_path if init_path.file?

      @activated = true
      return true
    end

    #
    # De-activates the repository by removing the {#lib_dir} from the
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
    # @return [Repository]
    #   The cleaned repository.
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
    # Syncs the {#cached_files} of the repository, and adds any new cached
    # files.
    #
    # @return [Repository]
    #   The cleaned repository.
    #
    # @since 1.0.0
    #
    def sync_cached_files!
      # activates the repository before caching it's objects
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

      # deactivates the repository
      deactivate!

      return self
    end

    #
    # Deletes any {#cached_files} associated with the repository.
    #
    # @return [Repository]
    #   The cleaned repository.
    #
    # @since 1.0.0
    #
    def clean_cached_files!
      self.cached_files.clear
      return self
    end

    #
    # Updates the repository, reloads it's metadata and syncs the
    # cached files of the repository.
    #
    # @yield [repo]
    #   If a block is given, it will be passed after the repository has
    #   been updated.
    #
    # @yieldparam [Repository] repo
    #   The updated repository.
    #
    # @return [Repository]
    #   The updated repository.
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
      initialize_metadata

      # save the repository
      if save
        # syncs the cached files of the repository
        sync_cached_files!
      end

      yield self if block_given?
      return self
    end

    #
    # Deletes the contents of the repository.
    #
    # @yield [repo]
    #   If a block is given, it will be passed the repository after it's
    #   contents have been deleted.
    #
    # @yieldparam [Repository] repo
    #   The deleted repository.
    #
    # @return [Repository]
    #   The deleted repository.
    #
    # @since 1.0.0
    #
    def uninstall!
      deactivate!

      FileUtils.rm_rf(self.path) if self.installed?

      # destroy any cached files first
      clean_cached_files!

      # remove the repository from the database
      destroy if saved?

      yield self if block_given?
      return self
    end

    #
    # Converts the repository to a String.
    #
    # @return [String]
    #   The name and domain of the repository.
    #
    def to_s
      "#{self.name}/#{self.domain}"
    end

    protected

    #
    # Loads the metadata from {METADATA_FILE} within the repository.
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
            self.authors << Author.first_or_new(:name => name, :email => email)
          end
        when Array
          metadata['authors'].each do |name|
            self.authors << Author.first_or_new(:name => name)
          end
        end
      end

      return self
    end

  end
end

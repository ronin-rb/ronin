#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/config'
require 'ronin/repo/repository'
require 'ronin/repo/extension'
require 'ronin/repo/exceptions/repository_cached'
require 'ronin/repo/exceptions/extension_not_found'

require 'yaml'

module Ronin
  module Repo
    class Cache

      # Path to cache file
      PATH = File.join(Config::PATH,'cache.yaml')

      # Path of cache file
      attr_reader :path

      # Hash of loaded repositories
      attr_reader :repositories

      #
      # Create a new Cache object with the specified _path_. The _path_
      # defaults to PATH. If a _block_ is given, it will be passed the
      # newly created Cache object.
      #
      def initialize(path=PATH,&block)
        @path = path
        @repositories = {}

        if File.file?(@path)
          File.open(@path) do |file|
            paths = YAML.load(file)

            if paths.kind_of?(Array)
              paths.each do |repo_path|
                add_repository(Repository.new(repo_path))
              end
            end
          end
        end

        block.call(self) if block
      end

      #
      # Adds the _repo_ to the cache. If a _block_ is given, it will
      # be passed the cache after the _repo_ is added. The _repo_
      # will be returned.
      #
      #   cache.add_repository(repo) # => Repository
      #
      #   cache.add_repository(repo) do |cache|
      #     puts "Repository #{repo} added"
      #   end
      #
      def add_repository(repo,&block)
        if has_repository?(repo.name)
          raise(RepositoryCached,"repository '#{repo}' already present in the cache '#{self}'",caller)
        end

        @repositories[repo.name] = repo

        block.call(self) if block

        save
        return self
      end

      #
      # Removes the _repo_ from the cache. If a _block_ is given, it
      # will be passed the cache. The cache will be returned, after the
      # _repo_ is removed.
      #
      #   cache.remove_repository(repo) # => Cache
      #
      #   cache.remove_repository(repo) do |cache|
      #     puts "Repository #{repo} removed"
      #   end
      #
      def remove_repository(repo,&block)
        unless has_repository?(repo.name)
          raise(RepositoryNotFound,"repository '#{repo}' is not present in the cache '#{self}'",caller)
        end

        @repositories.delete_if { |key,value| key==repo.name }

        block.call(self) if block

        save
        return self
      end

      #
      # Returns the repositories wich contain the extension with the
      # matching _name_.
      #
      #   cache.repositories_with_extension('exploits') # => Array
      #
      def repositories_with_extension(name)
        @repositories.values.select { |repo| repo.has_extension?(name) }
      end

      #
      # Iterates over the repositories of the cache, passing each
      # to the specified _block_.
      #
      #   cache.each_repository do |repo|
      #     puts repo.name
      #   end
      #
      def each_repository(&block)
        @repositories.each_values(&block)
      end

      #
      # Returns +true+ if the cache contains a repository with the matching
      # _name_, returns +false+ otherwise.
      #
      def has_repository?(name)
        @repositories.has_key?(name.to_s)
      end

      #
      # Returns the repository with the matching _name_.
      #
      def get_repository(name)
        unless has_repository?(name)
          raise(RepositoryNotFound,"repository '#{name}' not listed in cache '#{self}'",caller)
        end

        return @repositories[name.to_s]
      end

      #
      # Returns the paths of the repositories contained in the cache.
      #
      def repository_paths
        @repositories.values.map { |repo| repo.path }
      end

      #
      # Installs a Repository from the repository _metadata_ into
      # _install_path_. The _install_path_ defaults to the
      # Repository::REPOS_PATH joined with the _metadata_ name. If a
      # _block_ is given, it will be passed the cache after the Repository
      # is installed.
      #
      #   cache.install(metadata) # => Cache
      #
      #   cache.install(metadata,'custom') do |cache|
      #     puts cache.repositories_with_extension('exploits')
      #   end
      #
      def install(metadata,install_path=File.join(Repository::REPOS_PATH,metadata.name),&block)
        if has_repository?(metadata.name)
          raise(RepositoryCached,"repository '#{metadata}' already present in cache '#{self}'",caller)
        end

        metadata.download(install_path)

        block.call(self) if block
        return self
      end

      def add(path,&block)
        add_repository(Repository.new(path),&block)
      end

      def update(&block)
        @repositories.each_value { |repo| repo.update }

        block.call(self) if block
        return self
      end

      def save(cache_path=@path,&block)
        parent_dir = File.dirname(cache_path)

        unless File.directory?(parent_dir)
          FileUtils.mkdir_p(parent_dir)
        end

        block.call(self) if block

        File.open(cache_path,'w') do |file|
          YAML.dump(repository_paths,file)
        end

        return self
      end

      def extensions
        @repositories.values.map { |repo| repo.extensions }.flatten.uniq
      end

      def extension_paths
        @repositories.values.map { |repo| repo.extension_paths }.flatten.uniq
      end

      def each_extension(&block)
        extensions.each(&block)
      end

      def each_extension_path(&block)
        extension_paths.each(&block)
      end

      #
      # Returns +true+ if the cache has the extension with the matching
      # _name_, returns +false+ otherwise.
      #
      def has_extension?(name)
        @repositories.each_value do |repo|
          return true if repo.has_extension?(name)
        end

        return false
      end

      def extension(name,&block)
        unless has_extension?(name)
          raise(ExtensionNotFound,"extension '#{name}' does not exist",caller)
        end

        return Extension.create(name,&block)
      end

      def to_s
        @path.to_s
      end

    end
  end
end

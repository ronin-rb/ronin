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

require 'ronin/repo/repository'
require 'ronin/repo/extension'
require 'ronin/repo/exceptions/repository_cached'
require 'ronin/repo/exceptions/extension_not_found'
require 'ronin/repo/config'

require 'yaml'

module Ronin
  module Repo
    class Cache < Hash

      # Path of cache file
      attr_reader :path

      #
      # Create a new Cache object with the specified _path_. The _path_
      # defaults to <tt>Config::REPOS_CACHE_PATH</tt>. If a _block_ is
      # given, it will be passed the newly created Cache object.
      #
      def initialize(path=Config::REPOS_CACHE_PATH,&block)
        super()

        @path = File.expand_path(path)

        if File.file?(@path)
          File.open(@path) do |file|
            descriptions = YAML.load(file)

            if descriptions.kind_of?(Array)
              descriptions.each do |repo|
                if repo.kind_of?(Hash)
                  add(Repository.new(repo[:type],repo[:path],repo[:uri]))
                end
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
      #   cache.add(repo) # => Repository
      #
      #   cache.add(repo) do |cache|
      #     puts "Repository #{repo} added"
      #   end
      #
      def add(repo,&block)
        if has_repo?(repo.path)
          raise(RepositoryCached,"repository '#{repo}' already present in the cache '#{self}'",caller)
        end

        self << repo

        block.call(self) if block
        return self
      end

      #
      # Removes the _repo_ from the cache. If a _block_ is given, it
      # will be passed the cache. The cache will be returned, after the
      # _repo_ is removed.
      #
      #   cache.remove(repo) # => Cache
      #
      #   cache.remove(repo) do |cache|
      #     puts "Repository #{repo} removed"
      #   end
      #
      def remove(repo,&block)
        unless has_repo?(repo.path)
          raise(RepositoryNotFound,"repository #{repo.to_s.dump} is not present in the cache #{to_s.dump}",caller)
        end

        delete_if { |key,value| key==repo.path }

        block.call(self) if block
        return self
      end

      #
      # Returns +true+ if the cache contains the Repository with the
      # matching _path_, returns +false+ otherwise.
      #
      def has_repo?(path)
        has_key?(path.to_s)
      end

      #
      # Returns the Repository with the matching _path_.
      #
      def [](path)
        path = path.to_s

        unless has?(path)
          raise(RepositoryNotFound,"repository #{path.dump} not listed in cache #{to_s.dump}",caller)
        end

        return super(path)
      end

      #
      # Adds the specified _repo_ to the cache.
      #
      def <<(repo)
        self[repo.path.to_s] = repo
      end

      #
      # Returns the paths of the Repositories contained in the cache.
      #
      def paths
        keys
      end

      #
      # Returns the +Array+ of the cached Repositories.
      #
      def repos
        values
      end

      #
      # Returns the Repositories which match the specified _block_.
      #
      #   cache.repos_with do |repo|
      #     repo.author == 'dude'
      #   end
      #
      def repos_with(&block)
        repos.select(&block)
      end

      #
      # Returns the repositories which contain the extension with the
      # matching _name_.
      #
      #   cache.repos_with_extension('exploits') # => Array
      #
      def repos_with_extension(name)
        repos_with { |repo| repo.has_extension?(name) }
      end

      def extensions
        repos.map { |repo| repo.extensions }.flatten.uniq
      end

      def each_extension(&block)
        extensions.each(&block)
      end

      def extension_paths
        repos.map { |repo| repo.extension_paths }.flatten.uniq
      end

      def each_extension_path(&block)
        extension_paths.each(&block)
      end

      #
      # Returns +true+ if the cache has the extension with the matching
      # _name_, returns +false+ otherwise.
      #
      def has_extension?(name)
        repos.each do |repo|
          return true if repo.has_extension?(name)
        end

        return false
      end

      def extension(name,&block)
        name = name.to_s

        unless has_extension?(name)
          raise(ExtensionNotFound,"extension #{name.dump} does not exist",caller)
        end

        return Extension.create(name,&block)
      end

      #
      # Updates all the cached Repositories. If a _block_ is given it will
      # be passed the cache.
      #
      #   update # => Cache
      #
      #   update do |cache|
      #     puts "#{cache} is updated"
      #   end
      #
      def update(&block)
        repos.each { |repo| repo.update }

        block.call(self) if block
        return self
      end

      #
      # Saves the cache to the given _output_path_, where _output_path_
      # defaults to +@path+. If a _block_ is given, it will be passed
      # the cache before the cache has been saved.
      #
      def save(output_path=@path,&block)
        parent_dir = File.dirname(cache_path)

        unless File.directory?(parent_dir)
          FileUtils.mkdir_p(parent_dir)
        end

        block.call(self) if block

        File.open(cache_path,'w') do |file|
          descriptions = repos.map do |repo|
            {:type => repo.type, :path => repo.path, :uri => repo.uri}
          end

          YAML.dump(descriptions,file)
        end

        return self
      end

      #
      # Returns the +path+ of the cache.
      #
      def to_s
        @path.to_s
      end

    end
  end
end

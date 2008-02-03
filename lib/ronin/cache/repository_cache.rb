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

require 'ronin/cache/repository'
require 'ronin/cache/exceptions/repository_cached'
require 'ronin/cache/config'

require 'yaml'

module Ronin
  module Cache
    class RepositoryCache < Hash

      # Path of cache file
      attr_reader :path

      #
      # Create a new Cache object with the specified _path_. The _path_
      # defaults to <tt>Config::REPOSITORY_CACHE_PATH</tt>. If a _block_ is
      # given, it will be passed the newly created Cache object.
      #
      def initialize(path=Config::REPOSITORY_CACHE_PATH,&block)
        super()

        @path = File.expand_path(path)

        if File.file?(@path)
          File.open(@path) do |file|
            descriptions = YAML.load(file)

            if descriptions.kind_of?(Array)
              descriptions.each do |repo|
                if repo.kind_of?(Hash)
                  add(Repository.new(repo[:path],repo[:media],repo[:uri]))
                end
              end
            end
          end
        end

        block.call(self) if block
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
      def repositories
        values
      end

      #
      # Iterates over each repository in the repository cache, passing
      # each to the given specified _block_.
      #
      def each_repository(&block)
        each_value(&block)
      end

      #
      # Returns the Repositories which match the specified _block_.
      #
      #   cache.repositories_with do |repo|
      #     repo.author == 'the dude'
      #   end
      #
      def repositories_with(&block)
        values.select(&block)
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
        if has_repository?(repo.path)
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
        unless has_repository?(repo.path)
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
      def has_repository?(path)
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
        parent_dir = File.dirname(output_path)

        unless File.directory?(parent_dir)
          FileUtils.mkdir_p(parent_dir)
        end

        block.call(self) if block

        File.open(output_path,'w') do |output|
          descriptions = repositories.map do |repo|
            {:media => repo.media, :path => repo.path, :uri => repo.uri}
          end

          require 'pp'
          pp descriptions

          YAML.dump(descriptions,output)
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

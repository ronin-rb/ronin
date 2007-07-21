#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'repo/repositorymetadata'
require 'repo/repository'
require 'repo/category'
require 'repo/exceptions/repositorycached'
require 'repo/exceptions/categorynotfound'
require 'fileutils'
require 'yaml'

module Ronin
  module Repo

    # Ronin home directory
    RONIN_HOME_PATH = File.join(ENV['HOME'],'.ronin')

    # Ronin gem directory
    RONIN_GEM_PATH = File.join(RONIN_HOME_PATH,'gems')

    def Repo.load_cache(path=Cache::CACHE_PATH)
      Cache.new(path)
    end

    def Repo.cache
      Cache.current
    end

    class Cache

      include YAML

      # Path to cache file
      CACHE_PATH = File.join(RONIN_HOME_PATH,'cache.yml')

      # Path to repositories dir
      REPOS_PATH = File.join(RONIN_HOME_PATH,'repos')

      # Path of cache file
      attr_reader :path

      # Hash of loaded repositories
      attr_reader :repositories

      # Hash of all categories, each element containing the hash of
      # respositories that contain that category.
      attr_reader :categories

      # Global cache variable
      @@current_cache = nil

      def initialize(path=CACHE_PATH)
	@path = path
        @repositories = {}
	@categories = Hash.new { |hash,key| hash[key] = {} }

	@@current_cache = self

	if File.file?(@path)
	  File.open(@path) do |file|
	    paths = YAML.load(file)

	    if paths.kind_of?(Array)
	      paths.each do |repo_path|
		register_repository(Repository.new(repo_path))
	      end
	    end
	  end
	end
      end

      def Cache.current
	@@current_cache || Cache.new
      end

      def register_repository(repo)
	if has_repository?(repo.name)
	  raise RepositoryCached, "repository '#{repo}' already present in the cache '#{self}'", caller
	end

	@repositories[repo.name] = repo
	repo.categories.each do |category|
	  @categories[category][repo.name] = repo
	end

	yield if block_given?
      end

      def unregister_repository(repo)
	unless has_repository?(repo.name)
	  raise RepositoryNotFound, "repository '#{repo}' is not present in the cache '#{self}'", caller
	end

	@repository.delete_if { |key,value| key==repo.name }
	repo.categories.each do |category|
	  @categories[category].delete_if { |key,value| key==repo.name }
	end

	yield if block_given?
      end

      def has_repository?(name)
	@repositories.has_key?(name.to_s)
      end

      def get_repository(name)
	unless has_repository?(name)
	  raise RepositoryNotFound, "repository '#{name}' not listed in cache '#{self}'", caller
	end

	return @repositories[name.to_s]
      end

      def has_category?(name)
	@repositories.each_value do |repo|
	  return true if repo.has_category?(name)
	end
	return false
      end

      def category(name)
	unless has_category?(name)
	  raise CategoryNotFound, "category '#{name}' does not exist", caller
	end

        return Category.new(name)
      end

      def install(metadata,install_path=File.join(REPOS_PATH,metadata.name))
	if has_repository?(metadata.name)
	  raise RepositoryCached, "repository '#{metadata}' already present in cache '#{self}'", caller
	end

	return metadata.download(install_path)
      end

      def link(repo_path)
	register_repository(Repository.new(repo_path))
      end

      def update
	@repositories.each_value { |repo| repo.update }
      end

      def save(cache_path=@path)
	unless File.exists?(cache_path)
	  FileUtils.mkdir_p(File.dirname(cache_path))
	end

	File.open(cache_path,'w') do |file|
	  YAML.dump(@repositories.values.map { |repo| repo.path }, file)
	end

	return self
      end

      def to_s
	@path
      end

    end
  end
end

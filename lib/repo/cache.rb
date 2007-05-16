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
require 'repo/exceptions/categorynotfound'
require 'rexml/document'

module Ronin
  module Repo

    RONIN_HOME_PATH = File.join(ENV['HOME'],'.ronin')

    RONIN_GEM_PATH = RONIN_HOME_PATH

    def load_cache(path=Config::CONFIG_PATH)
      $current_cache = Config.new(path)
    end

    def cache
      return load_cache if $current_cache.nil?
      return $current_cache
    end

    class Config

      include REXML

      # Path to cache file
      CONFIG_PATH = File.join(RONIN_HOME_PATH,'cache')

      # Path to repositories dir
      REPOS_PATH = File.join(RONIN_HOME_PATH,'repos')

      # Path of cache file
      attr_reader :path

      # Hash of loaded repositories
      attr_reader :repositories

      # Hash of all categories, each element containing the hash of
      # respositories that contain that category.
      attr_reader :categories

      def initialize(path=CONFIG_PATH)
	@path = path
        @repositories = {}
	@categories = Hash.new { |hash,key| hash[key] = {} }

	read
      end

      def register_repository(repo)
	if has_repository?(repo.name)
	  raise "repository '#{repo}' already present in the cache '#{self}'", caller
	end

	@repositories[repo.name] = repo
	@categories.each do |hash,key|
	end
      end

      def unregister_repository(repo)
	unless has_repository?(repo.name)
	  raise "repository '#{repo}' is not present in the cache '#{self}'", caller
	end

	@repository[repo.name] = nil
	return repo
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

      def get_category(name)
	unless has_category?(name)
	  raise CategoryNotFound, "category '#{name}' does not exist", caller
	end

        return Category.new(name)
      end

      def install(metadata,install_path=File.join(REPOS_PATH,metadata.name))
	if has_repository?(metadata.name)
	  raise "repository '#{metadata}' already present in cache '#{self}'", caller
	end

	return metadata.download(install_path)
      end

      def link(repo_path)
	Repository.new(repo_path) do |new_repo|
	  add_repository(new_repo)
	  write_cache
	end
      end

      def update
	@repositories.each_value { |repo| repo.update }
      end

      def read
	return unless File.file?(@path)

	cache_doc = Document.new(File.new(@path))
	cache_doc.elements.each('/ronin/cache/repository') do |repo|
	  repo_name = repo.attribute('name').to_s
	  repo_path = repo.get_text.to_s

	  add_repository(Repository.new(repo_name,repo_path))
	end
      end

      def write
	# create skeleton cache document
	new_cache = Document.new('<ronin></ronin>')
	cache_elem = Element.new('cache',new_cache.root)

	# populate with repositories
	@repositories.each do |repo|
	  repo_elem = Element.new('repository',cache_elem)
	  repo_elem.add_attribute('name',repo.name)
	  repo_elem.add_text(repo.path)
	end

	# save cache document
	new_cache << XMLDecl.new
	new_cache.write(File.new(@path,'w'),0)
      end

      def to_s
	@path
      end

    end

    private

    # Current operating cacheuration
    $current_cache = nil
  end
end

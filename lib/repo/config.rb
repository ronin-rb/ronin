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

    def open_config(path=Config::CONFIG_PATH)
      $current_config = Config.new(path)
    end

    def config
      return open_config if $current_config.nil?
      return $current_config
    end

    class Config

      include REXML

      # Path to config file
      CONFIG_PATH = File.join(ENV['HOME'],'.ronin','config')

      # Path to repositories dir
      REPOS_PATH = File.join(ENV['HOME'],'.ronin','repos')

      # Path of config file
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

	if File.file?(path)
	  config_doc = Document.new(File.new(path))
	  config_doc.elements.each('/ronin/config/repository') do |repo|
	    repo_name = repo.attribute('name').to_s
	    repo_path = repo.get_text.to_s

	    add_repository(Repository.new(repo_name,repo_path))
	  end
	end
      end

      def add_repository(repo)
	if has_repository?(repo.name)
	  raise "repository '#{repo}' already present in config '#{self}'", caller
	end

	@repositories[repo.name] = repo
	repo.categories.each do |category|
	  @categories[category][repo.name] = repo
	end
	return repo
      end

      def has_repository?(name)
	@repositories.has_key?(name.to_s)
      end

      def get_repository(name)
	unless has_repository?(name)
	  raise RepositoryNotFound, "repository '#{name}' not listed in config file '#{self}'", caller
	end

	return @repositories[name.to_s]
      end

      def has_category?(name)
	@categories.has_key?(name.to_s)
      end

      def get_category(name)
	unless has_category?(name)
	  raise CategoryNotFound, "category '#{name}' does not exist", caller
	end

        Category.new(name)
      end

      def install(metadata,install_path=File.join(REPOS_PATH,metadata.name))
	if has_repository?(metadata.name)
	  raise "repository '#{metadata}' already present in config '#{self}'", caller
	end

	metadata.download(install_path)

	return Repository.new(install_path) do |new_repo|
	  add_repository(new_repo)
	  write
	end
      end

      def link(repo_path)
	Repository.new(repo_path) do |new_repo|
	  add_repository(new_repo)
	  write
	end
      end

      def update
	@repositories.each_value { |repo| repo.update }
      end

      def write(config_path=@path)
	# create skeleton config document
	new_config = Document.new('<ronin></ronin>')
	config_elem = Element.new('config',new_config.root)

	# populate with repositories
	@repositories.each do |repo|
	  repo_elem = Element.new('repository',config_elem)
	  repo_elem.add_attribute('name',repo.name)
	  repo_elem.add_text(repo.path)
	end

	# save config document
	new_config << XMLDecl.new
	new_config.write(File.new(config_path,'w'),0)
      end

      def to_s
	@path
      end

    end

    private

    # Current operating configuration
    $current_config = nil
  end
end

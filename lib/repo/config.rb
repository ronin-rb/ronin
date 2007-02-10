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

require 'category'
require 'group'
require 'extensions/kernel'
require 'exceptions/repositorynotfound'
require 'exceptions/categorynotfound'

module Ronin
  module Repo

    # Current operating configuration
    $current_config = nil

    class Config

      # Path of config file
      attr_reader :path

      # Hash of loaded repositories
      attr_reader :repositories

      # Hash of group stubs
      attr_reader :groups

      # Cache of loaded groups
      attr_reader :category_cache

      # Cache of loaded groups
      attr_reader :group_cache

      def initialize(path=CONFIG_PATH)
	@path = path
        @repositories = {}
	@groups = {}

	@category_cache = []
	@group_cache = []

        # TODO: parse REPOS_CONFIG and create Hash of repositories.
      end

      def get_repository(name)
	unless @repositories.has_key(name)
	  raise, RepositoryNotFound, "repository '#{name}' not listed in config file '#{self}'"
	end

	return @repositories[name]
      end

      def get_category(repo,name)
	@category_cache.each do |category|
	  return category if (category.repo.name==repo && category.name==name)
	end

        repository = get_repository(repo)
        new_category = repository.load_category(name)
	category_cache << new_category
	return new_category
      end

      def get_group(name)
	@group_cache.each do |group|
	  return group if group.name==name
	end

	unless @groups.has_key?(name)
	  raise, CategoryNotFound, "category '#{name}' not found in config file '#{self}'"
	end

	group_stub = @groups[name]
	group_groups = []
	group_stub.repositories.each do |repository|
	  group_groups << repository.get_category(name)
	end

	group_context_path = 'categories' + File.SEPARATOR + name + File.SEPARATOR + name + '.rb'
	if group_stub.context_repo
	  group_stub.context_repo.load_file(group_context_path)
	else
	  unless File.file?(SHARE_PATH + group_context_path)
	    raise, "category '#{name}' must have a context directory in atleast one repositories 'categories' directory"
	  end
	  load(SHARE_PATH + group_context_path)
	end

	new_group = Group.new(name,group_groups,$current_block)
	group_cache << new_group
	return new_group
      end

      def to_s
	return @path
      end

      private

      def parse_config
      end

    end
  end
end

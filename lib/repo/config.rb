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

require 'repo/repository'
require 'repo/category'
require 'repo/group'
require 'repo/exceptions/repositorynotfound'
require 'repo/exceptions/categorynotfound'

module Ronin
  module Repo

    def open_config(path=CONFIG_PATH)
      $current_config = Config.new(path)
    end

    def config
      return open_config if $current_config.nil?
      return $current_config
    end

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

      def initialize(path)
	@path = path
        @repositories = {}
	@groups = {}

	@category_cache = []
	@group_cache = []

        # TODO: parse REPOS_CONFIG and create Hash of repositories.
      end

      def get_repository(name)
	unless @repositories.has_key(name)
	  raise RepositoryNotFound, "repository '#{name}' not listed in config file '#{self}'", caller
	end

	return @repositories[name]
      end

      def get_category(repo,name)
	@category_cache.each do |category|
	  return category if (category.repo.name==repo && category.name==name)
	end

        return get_repository(repo).load_category(name)
      end

      def cache_category(category)
	@category_cache << category
      end

      def get_group(name)
	@group_cache.each do |group|
	  return group if group.name==name
	end

	unless @groups.has_key?(name)
	  raise CategoryNotFound, "category '#{name}' not found in config file '#{self}'", caller
	end

	return Group.new(@groups[name])
      end

      def cache_group(group)
	@group_cache << group
      end

      def to_s
	return @path
      end

      private

      # TODO: fill this in later, joyous lexical parsing.
      def parse_config
      end

    end

    protected

    # Current operating configuration
    $current_config = nil

  end
end

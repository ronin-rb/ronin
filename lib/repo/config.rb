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

      # Hash of all categories, each element containing the hash of
      # respositories that contain that category.
      attr_reader :categories

      def initialize(path)
	@path = path
        @repositories = {}
	@categories = {}

        # TODO: parse path and load data
      end

      def get_repository(name)
	unless has_repository?(name)
	  raise RepositoryNotFound, "repository '#{name}' not listed in config file '#{self}'", caller
	end

	return @repositories[name]
      end

      def has_repository?(name)
	return @repositories.has_key?(name)
      end

      def get_category(name)
        return Category.new(name)
      end

      def has_category?(name)
	return @categories.has_key?(name)
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

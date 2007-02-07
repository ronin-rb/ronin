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

require 'exceptions/actionnotfound'

module Ronin
  module Repo
    class CategoryDependency

      # Name of repository
      attr_reader :repo

      # Name of Category
      attr_reader :category

      def initialize(repo=nil,category)
	@repo = repo
	@category = category
      end

      def to_s
	return @category unless @repo
	return @repo + File.SEPARATOR + @category
      end

    end

    class Category

      # Repository
      attr_reader :repo

      # Name of the Category
      attr_reader :name

      # Depedencies on other Categories
      attr_reader :deps

      # Actions
      attr_reader :actions

      def initialize(repo,name)
	@repo = repo
	@name = name

	@deps = {}
	@actions = []
      end

      def setup
	action('setup')
      end

      def load
	action('load')
      end

      def teardown
	action('teardown')
      end

      def action(name)
	unless actions[name]
	  raise, ActionNotFound, "can not find action '#{name}' in category '#{@name}'"
	end

	actions[name].call(self.path)
      end

      def path
	return @repo.path + File.SEPARATOR + @name
      end

      def to_s
	return path
      end

    end
  end
end

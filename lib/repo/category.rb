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

      def resolve(config)
	if @repo
	  repository = config.get_repository(@repo)
	  unless repository
	    raise, MissingRepository, "missing repository '#{repo}'"
	  end

	  return repository.get_category(@category)
	end

	return config.get_category(@category)
      end

    end

    class Category

      # Name of the Category
      attr_reader :name

      # Depedencies on other Categories
      attr_reader :deps

      def initialize(name,deps)
	@name = name
	@deps = deps
      end

    end
  end
end

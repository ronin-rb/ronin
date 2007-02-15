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

require 'repo/fileaccess'
require 'repo/category'
require 'repo/exceptions/categorynotfound'

module Ronin
  module Repo
    class Repository

      include FileAccess

      # Name of the Repository
      attr_reader :name

      # URL of the Repository source
      attr_reader :url

      # Local path to the Repository
      attr_reader :path

      def initialize(name,url,path)
        @name = name
        @url = url
	@path = path
      end

      def get_category(name)
	unless has_category?(name)
	  raise CategoryNotFound, "category '#{name}' not found in repository '#{@name}'", caller
	end

	category_context_path = @path + File.SEPARATOR + name + File.SEPARATOR + name + '.rb'
	if File.file?(category_context_path)
	  load(category_context_path)
	  return Category.new(self,name,$current_block)
	end

	return Category.new(self,name)
      end

      def has_category?(category)
	return false if (category == 'categories' || category.include?('.') || category.include?(File.SEPARATOR))
	return contains_directory?(category)
      end
    end
  end
end

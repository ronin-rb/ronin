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

      # Description
      attr_reader :description

      def initialize(name,url,path,descriptor="")
        @name = name
        @url = url
	@path = path
	@description = description
      end

      def has_category?(category)
	return false if (category == Category.CONTROL_DIR || category.include?(File.SEPARATOR))
	return contains_dir?(category)
      end

      def to_s
	@name
      end

    end
  end
end

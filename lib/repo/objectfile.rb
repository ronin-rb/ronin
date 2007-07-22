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

require 'og'

module Ronin
  module Repo
    class ObjectFile

      attr_reader :path, String

      attr_reader :mtime, Time

      def initialize(path,mtime)
	@path = path
	@mtime = mtime
      end

      def ObjectFile.timestamp(path)
	obj_file = ObjectFile.new(path,File.mtime(path))
	obj_file.save

	ronin_load_objects(path).each do |obj|
	  obj.cache(obj_file)
	end

	return obj_file
      end

      def is_fresh?
	File.mtime(@path)==@mtime
      end

      def is_stale?
	File.mtime(@path)!=@mtime
      end

      def timestamp
	@mtime = File.mtime(@path)
	update
      end

    end
  end
end

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

require 'repo/context'
require 'repo/category'
require 'repo/group_stub'

module Ronin
  module Repo
    class Group < Context

      include FileAccess

      # Name
      attr_reader :name

      def initialize(name,categories,path,&block)
	@name = name
	@deps = categories
	@path = path

	super(&block)
      end

      def contains?(path)
	FileAccess::contains?(path)
	@deps.each do |dep|
	  return true if dep.contains?(path)
	end
      end

      def contains_file?(path)
	FileAccess::contains_file?(path)
	@deps.each do |dep|
	  return true if dep.contains_file?(path)
	end
      end

      def contains_directory?(path)
	FileAccess::contains_directory?(path)
	@deps.each do |dep|
	  return true if dep.contains_directory?(path)
	end
      end

      def load_file(path)
	return FileAccess::load_file(path) if FileAccess::contains_file?(path)
	@deps.each do |dep|
	  if dep.contains_file?(path)
	    return dep.load_file(path)
	  end
	end
      end

      def require_file(path)
	return FileAccess::require_file(path) if FileAccess::contains_file?(path)
	@deps.each do |dep|
	  if dep.contains_file?(path)
	    return dep.require_file(path)
	  end
	end
      end

      def to_s
	@name
      end

    end
  end
end

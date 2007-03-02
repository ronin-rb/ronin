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
require 'repo/exceptions/categorynotfound'
require 'repo/config'
require 'repo/objectcontext'
require 'repo/exploitcontext'
require 'repo/platformexploitcontext'
require 'repo/bufferoverflowcontext'
require 'repo/formatstringcontext'
require 'repo/payloadcontext'

module Ronin
  module Repo
    class Category < Context

      # Name of category
      attr_reader :name

      # Category control directory
      CONTROL_DIR = 'categories'

      def initialize(name)
	super

	@name = name
	depend(@name)
      end

      def depend(name)
	if name.include?(File::SEPARATOR)
	  parts = name.split(File::SEPARATOR)
	  unless parts.length==2
	    raise "bad category dependencies string '#{name}'", caller
	  end

	  repository = current_config.get_repository(parts[0])
	  category = parts[1]

	  unless (name!=CONTROL_DIR && current_config.has_category?(category))
	    raise CategoryNotFound, "category '#{category}' does not exist", caller
	  end

	  return depend_context(category,File.join(repository.path,category))
	end

	unless (name!=CONTROL_DIR && current_config.has_category?(name))
	  raise CategoryNotFound, "category '#{name}' does not exist", caller
	end

	current_config.categories[name].each_value do |repository|
	  if repository.contains_dir?(File.join(CONTEXT_DIR,name))
	    depend_context(name,File.join(repository.path,CONTEXT_DIR,name))
	    break
	  end
	end

	current_config.categories[name].each_value do |repository|
	  depend_context(File.join(repository,name),File.join(repository.path,name))
	end
	return true
      end

      def to_s
	return @name
      end

    end
  end
end

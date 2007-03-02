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

module Ronin
  module Repo
    class ObjectContext < Context

      # Object metadata
      attr_reader :metadata

      # Path to object control file

      def initialize(path,category)
	super
	@paths = category.paths
	@path = path

	@metadata = { :name => "", :version => "", :author => "" }
      end

      def initialize_object
	depend_context(File.basename(@path,'.rb'),File.dirname(@path))
      end

      protected

      def ObjectContext.attr_metadata(*ids)
	for id in ids
	  module_eval <<-"end_eval"
	    def #{id}
	      @metadata[#{id}]
	    end

	    def #{id}=(data)
	      @metadata[#{id}] = data
	    end
	  end_eval
	end
      end

      # Name of the object
      attr_metadata :name
      
      # Version of the object
      attr_metadata :version
      
      # Author of the object
      attr_metadata :author

    end

    def Repo::attr_object(*ids)
      for id in ids
	name = id.id2name
	module_eval <<-"end_eval"
	  class Category < Context
	    def new_#{name.downcase.chomp("context")}(path,*args)
	      ronin_path(path) do |file|
	        obj = #{name}.new(file,self,args)
	        obj.initialize_object
	        return obj
	      end
	    end
	  end
	end_eval
      end
    end

    # Object constructor for ObjectContext
    attr_object :ObjectContext
  end
end

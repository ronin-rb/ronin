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
require 'repo/objectmetadata'
require 'repo/authorcontext'

module Ronin
  module Repo
    class ObjectContext < Context

      include ObjectMetadata

      # Object file
      attr_reader :file

      # Object metadata
      attr_accessor :metadata

      def initialize(path)
	@file = path

	# initialize metadata
	metadata_set(:name,"")
	metadata_set(:version,"")
	metadata_set(:authors,{})

	super(File.basename(path,'.rb'),File.dirname(path))
      end

      def create
	# dummy place holder
      end

      protected

      def ObjectContext.attr_object(id)
	attr_context id

	Ronin::module_eval <<-"end_eval"
	  def ronin_load_#{id}(path,&block)
	    obj = #{self.name}.new(path)
	    if block
	      obj.setup
	      v = block.call(obj)
	      obj.teardown
	      return v
	    else
	      return obj
	    end
	  end

	  def ronin_create_#{id}(path)
	    ronin_load_#{id}(path) { |obj| obj.create }
	  end
	end_eval
      end

      # Name of the object
      attr_metadata :name
      
      # Version of the object
      attr_metadata :version
      
      # Authors of the object
      attr_metadata :authors

      def author(name,&block)
	new_author = AuthorContext.new(name,&block)
	authors[new_author.name] = new_author
	return new_author
      end

    end
  end
end

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
require 'repo/author'
require 'repo/exceptions/objectnotfound'

module Ronin
  module Repo
    class ObjectContext < Context

      include ObjectMetadata

      def initialize(name='')
	super(name)

	# initialize metadata
	metadata_set(:type,context_id)
	metadata_set(:name,"")
	metadata_set(:version,"")
	metadata_set(:authors,{})
      end

      def create
	# dummy place holder
      end

      def ObjectContext.objects
	@@objects ||= {}
      end

      def ObjectContext.object_defined?(name)
	ObjectContext.objects.has_key?(name.to_s)
      end

      def ObjectContext.object(name)
	ObjectContext.objects[name.to_s]
      end

      protected

      def ObjectContext.attr_object(id)
	attr_context id

	objects[id.to_s] = self

	Ronin::module_eval <<-"end_eval"
	  def ronin_create_#{id}(path)
	    ronin_load_#{id}(path) { |obj| obj.create }
	  end
	end_eval
      end

      def author(name,&block)
	return authors[new_author.name] = AuthorContext.new(name,&block)
      end

    end

    def Repo.ronin_load_object(path)
      unless File.file?(path)
	raise ObjectNotFound, "object context '#{path}' does not exist", caller
      end

      # load object context file
      load(path)

      name = File.basename(path,'.rb')
      objects = []

      # copy contexts hash and clear it
      new_contexts = ronin_contexts.clone
      ronin_contexts.clear

      new_contexts.each do |key,value|
	unless ObjectContext.object_defined?(key)
	  raise ObjectNotFound, "object context '#{key}' is unknown", caller
	end

	# create new object context
	new_obj = ObjectContext.object(key).new(name)

	new_obj.paths << File.dirname(path)
	value.each { |block| new_obj.instance_eval(&block) }

	objects << new_obj
      end

      return objects
    end
  end
end

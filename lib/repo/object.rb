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
require 'repo/objectwrapper'
require 'repo/author'
#require 'repo/objectcache'
require 'repo/exceptions/objectnotfound'

module Ronin
  module Repo
    class ObjectContext < Context

      include ObjectWrapper

      def initialize(name=context_id,&block)
	@version = ''
	@authors = {}

	super(name,&block)
      end

      def ObjectContext.create(path,&block)
	unless File.file?(path)
	  raise ObjectNotFound, "object context '#{path}' does not exist", caller
	end

	super(path,&block)
      end

      def ObjectContext.object_contexts
	@@object_contexts ||= {}
      end

      def ObjectContext.has_object_context?(name)
	ObjectContext.object_contexts.has_key?(name.to_sym)
      end

      def ObjectContext.create_object(type,name=type,&block)
	type = type.to_sym
	name = name.to_s

	unless ObjectContext.has_object_context?(type)
	  raise ObjectNotFound, "unknown object context '#{type}'", caller
	end

	return ObjectContext.object_contexts[type].new(name,&block)
      end

      def ObjectContext.load_object(path,&block)
	path = File.expand_path(path)

	unless File.file?(path)
	  raise ObjectNotFound, "object context '#{path}' does not exist", caller
	end

	load_context_blocks(path)
	type = ronin_contexts.keys[0]
	obj_block = ronin_contexts.values[0]

	new_obj = ObjectContext.create_object(type,File.basename(path,'.rb'),&obj_block)
	new_obj.path = path
	new_obj.paths << File.dirname(path)

	block.call(new_obj) if block
	return new_obj
      end

      def ObjectContext.metatypes
	@@metatypes ||= Hash.new { |hash,key| hash[key] = {} }
      end

      def metadata
	data = {}

	ObjectCache.metatypes[self.context_id].keys.each do |name|
	  data[name] = send(name)
	end
	return data
      end

      protected

      def ObjectContext.object_context(id)
	context id

	ObjectContext.object_contexts[id.to_sym] = self
      end

      def ObjectContext.metadata(id,cls=String)
	ObjectContext.metatypes[self.context_id][id.to_sym] = cls
      end

      # Object context id of the object
      object_context :object

      # Name of the object
      metadata :name

      # Version of the object
      metadata :version

      # Authors of the object
      metadata :authors, Hash

      def author(name,&block)
	@authors[name] = AuthorContext.new(name,&block)
      end

      def encapsulate
	Object.new
      end

    end
  end
end

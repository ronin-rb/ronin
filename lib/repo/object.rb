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
require 'repo/exceptions/objectnotfound'

module Ronin
  module Repo
    class ObjectContext < Context

      include ObjectWrapper

      def initialize(name='')
	super(name)

	@version = ''
	@authors = {}
      end

      def ObjectContext.create(path,&block)
	unless File.file?(path)
	  raise ObjectNotFound, "object context '#{path}' does not exist", caller
	end

	super(path,&block)
      end

      def metadata
	data = {}

	ObjectCache.metatypes[self.context_id].keys.each do |name|
	  data[name] = send(name)
	end
	return data
      end

      def ObjectContext.object_contexts
	@@object_contexts ||= {}
      end

      def ObjectContext.has_object_context?(name)
	ObjectContext.object_contexts.has_key?(name.to_s)
      end

      protected

      def ObjectContext.object_context(id)
	context id

	ObjectContext.object_contexts[id.to_s] = self
      end

      def ObjectContext.metadata(id,cls=String)
	ObjectCache.metatype[self.context_id][id.to_s] = cls
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

    def Repo.ronin_load_object(type,path,&block)
      type = type.to_s

      unless ObjectContext.has_object_context?(type)
	raise ObjectNotFound, "object context type '#{type}' is unknown", caller
      end

      unless File.file?(path)
	raise ObjectNotFound, "object context '#{path}' does not exist", caller
      end

      return ObjectContext.object_contexts[type].create(path,&block)
    end

    def Repo.ronin_load_objects(path,&block)
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

      new_contexts.each do |type,blocks|
	unless ObjectContext.has_object_context?(type)
	  raise ObjectNotFound, "object context '#{type}' is unknown", caller
	end

	# create new object context
	new_obj = ObjectContext.object_contexts[type].new(name)

	# add the initial path
	new_obj.paths << File.dirname(path)

	# evaulate context blocks
	blocks.each { |context_block| new_obj.instance_eval(&context_block) }

	block.call(new_obj) if block

	objects << new_obj
      end

      return objects
    end
  end
end

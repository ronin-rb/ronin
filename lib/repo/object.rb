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

      def initialize(name='')
	super(name)
      end

      def ObjectContext.create(path,&block)
	unless File.file?(path)
	  raise ObjectNotFound, "object context '#{path}' does not exist", caller
	end

	super(path,&block)
      end

      def encapsulate
	Object.new
      end

      def object
	@object ||= encapsulate
      end

      def object=(value)
	@object = value
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

      def method_missing(sym,*args)
	if object
	  return object.send(sym,*args) if object.respond_to?(sym)
	end

	return super(sym,*args)
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
	unless ObjectContext.has_object_context?(key)
	  raise ObjectNotFound, "object context '#{key}' is unknown", caller
	end

	# create new object context
	new_obj = ObjectContext.object_contexts[key].new(name)

	new_obj.paths << File.dirname(path)
	value.each { |block| new_obj.instance_eval(&block) }

	objects << new_obj
      end

      return objects
    end
  end
end

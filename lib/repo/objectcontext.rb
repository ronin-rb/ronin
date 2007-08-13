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

require 'objectcache'
require 'repo/contextable'
require 'repo/objectfile'

require 'og'
require 'glue/taggable'
require 'rexml/document'

module Ronin
  module Repo
    module ObjectContext
      include Contextable

      def ObjectContext.object_contexts
	@@object_contexts ||= {}
      end

      def ObjectContext.is_object_context?(id)
	ObjectContext.object_contexts.has_key?(id.to_sym)
      end

      def ObjectContext.load_objects(path)
	path = File.expand_path(path)

	contexts = Contextable.load_contexts(path)
	objects = []
	
	contexts.each do |id,block|
	  unless ObjectContext.is_object_context?(id)
	    raise ObjectNotFound, "object context '#{id}' unknown", caller
	  end

	  new_obj = ObjectContext.object_contexts[id].new
	  new_obj.instance_eval(&block)
	  new_obj.object_path = path

	  objects << new_obj
	end

	return objects
      end

      def ObjectContext.load_object(type,path)
	type = type.to_sym

	unless ObjectContext.is_object_context?(type)
	  raise ObjectNotFound, "object context '#{type}' unknown", caller
	end

	return ObjectContext.object_contexts[type].create_object(path)
      end

      protected

      def Object.object_context(id)
	# contextify the class
        contextify(id)

	class_eval do
	  # Make all object contexts taggable
	  include Taggable

	  # The object path from which this object context was loaded
	  attr_accessor :object_path, String

	  before %{
	    path = res[res.fields.index('object_path')]
	    if path
	      load_object(path)

	      @oid = res[res.fields.index('oid')]
	      return
	    end
	  }, :on => :og_read

          def self.create_object(path,&block)
            path = File.expand_path(path)

            new_obj = self.new
            new_obj.load_object(path,&block)

            return new_obj
          end

	  def load_object(path,&block)
	    path = File.expand_path(path)

	    load_context(path)
	    @object_path = path

	    block.call(self) if block
	    return self
	  end
	end

        # define kernel-level context method
        Kernel.module_eval %{
	  def ronin_#{id}(*args,&block)
            if ronin_context_pending?
              ronin_contexts[:#{id}] = block
              return nil
            else
	      new_obj = #{self}.new(*args)
	      new_obj.instance_eval(&block)
	      return new_obj
            end
	  end
	}

        # define Repo-level object loader method
        Ronin.module_eval %{
          def ronin_load_#{id}(path,&block)
	    if (File.extname(path)=='.xml' && #{self}.respond_to?(:parse_xml))
	      return #{self}.parse_xml(REXML::Document.new(path))
	    else
	      return #{self}.create_object(path,&block)
	    end
          end
	}

	# add the class to the global list of object contexts
	ObjectContext.object_contexts[id] = self
      end
    end
  end
end

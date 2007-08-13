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

require 'repo/contextable'
require 'repo/objectfile'

require 'og'
require 'glue/taggable'
require 'rexml/document'

module Ronin
  module Repo
    module ObjectContext
      include Contextable

      def self.create_object(path,&block)
	path = File.expand_path(path)

	new_obj = self.new
	new_obj.load_context(path)
	new_obj.object_file = ObjectFile.find_by_path(path)

	block.call(new_obj) if block
	return new_obj
      end

      def cache(obj_file)
	@object_file = obj_file
	save
      end

      def update_cache
	# update the object-file timestamp
	@object_file.timestamp

	# load and cache the new object
	new_obj = ronin_load_object(content_id,@object_file.path)
	new_obj.save

	return new_obj
      end

      def ObjectContext.object_contexts
	@@object_contexts ||= {}
      end

      def ObjectContext.is_object_context?(id)
	ObjectContext.object_contexts.has_key?(id.to_sym)
      end

      def ObjectContext.load_objects(path)
	contexts = Contextable.load_contexts
	objects = []
	
	contexts.each do |id,block|
	  unless ObjectContext.is_object_context?(id)
	    raise ObjectNotFound, "object context '#{type}' unknown", caller
	  end

	  new_obj = ObjectContext.object_contexts[type].new
	  new_obj.instance_eval(&block)

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

	# Og enchant the class and make Taggable
	is Taggable
	has_one :object_file, ObjectFile

	# add the class to the global list of object contexts
	ObjectContext.object_contexts[id] = self
      end
    end
  end
end

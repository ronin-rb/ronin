#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/cache/context'
require 'ronin/cache/object_file'
require 'ronin/cache/extensions/object_context'
require 'ronin/ronin'

require 'og'
require 'og/model/taggable'
require 'rexml/document'

module Ronin
  module Cache
    module ObjectContext
      #
      # Returns the Hash of all defined object-contexts.
      #
      def ObjectContext.object_contexts
        @@object_contexts ||= {}
      end

      #
      # Returns +true+ if there is an object-context defined with the
      # specified _name_, returns +false+ otherwise.
      #
      def ObjectContext.is_object_context?(name)
        ObjectContext.object_contexts.has_key?(name.to_sym)
      end

      #
      # Loads all object-contexts from the specified _path_, returning an 
      # Array of the loaded objects.
      #
      #   ObjectContext.load_objects('/path/to/obj.rb') # => [...]
      #
      def ObjectContext.load_objects(path)
        path = File.expand_path(path)
        objects = []

        Context.load_contexts(path).each do |id,block|
          unless ObjectContext.is_object_context?(id)
            raise(ObjectNotFound,"unknown object context '#{id}'",caller)
          end

          new_obj = ObjectContext.object_contexts[id].new
          new_obj.instance_eval(&block)
          new_obj.object_path = path

          objects << new_obj
        end

        return objects
      end

      #
      # Load the object-context of the specified _name_, from the specified
      # _path_ with the given _args_. If no object-contexts were defined
      # with the specified _name_, an ObjectNotFound exception will be
      # raised.
      #
      #   ObjectContext.load_object('payload','/path/to/custom_payload.rb')
      #     # => Payload
      #
      def ObjectContext.load_object(name,path,*args)
        name = name.to_sym

        unless ObjectContext.is_object_context?(name)
          raise(ObjectNotFound,"unknown object context '#{name}'",caller)
        end

        return ObjectContext.object_contexts[name].create_object(path,*args)
      end

      def ObjectContext.namify(base)
        Context.namify(base)
      end

    end
  end
end

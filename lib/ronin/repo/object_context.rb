#
# Ronin - A ruby development environment designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/repo/context'
require 'ronin/repo/object_file'
require 'ronin/ronin'

require 'og'
require 'og/model/taggable'
require 'rexml/document'

module Ronin
  module Repo
    module ObjectContext
      include Context

      def ObjectContext.object_contexts
        @@object_contexts ||= {}
      end

      def ObjectContext.is_object_context?(id)
        ObjectContext.object_contexts.has_key?(id.to_sym)
      end

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

      def ObjectContext.load_object(type,path,*args)
        type = type.to_sym

        unless ObjectContext.is_object_context?(type)
          raise(ObjectNotFound,"unknown object context '#{type}'",caller)
        end

        return ObjectContext.object_contexts[type].create_object(path,*args)
      end

      def ObjectContext.namify(base)
        Context.namify(base)
      end

      protected

      def Object.object_contextify(id=ObjectContext.namify(self))
        class_eval do
          # contextify the class
          contextify(id)

          # make the class taggable
          include Taggable

          # the path of the object context file
          attr_accessor :object_path, String

          before %{
            path = res[res.fields.index('object_path')]
            if path
              load_object(path)

              @oid = res[res.fields.index('oid')]
              return
            end
          }, :on => :og_read
        end

        if Ronin.object_cache_loaded?
          # manage classes after the object cache has been setup
          Ronin.object_cache.manage(self)
        end

        meta_def(:create_object) do |path,*args|
          path = File.expand_path(path)

          new_obj = self.new(*args)
          new_obj.load_object(path)

          return new_obj
        end

        class_def(:load_object) do |path|
          path = File.expand_path(path)

          load_context(path)

          @object_path = path
          return self
        end

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

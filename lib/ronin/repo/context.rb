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

require 'ronin/repo/extensions/kernel'
require 'ronin/repo/exceptions/context_not_found'
require 'ronin/extensions/meta'

module Ronin
  module Repo
    module Context
      def Context.contexts
        @@contexts ||= {}
      end

      def Context.is_context?(id)
        ObjectContext.contexts.has_key?(id.to_sym)
      end

      def Context.load_contexts(path)
        path = File.expand_path(path)
        contexts = []

        Context.load_contexts(path).each do |id,block|
          unless Context.is_context?(id)
            raise(ContextNotFound,"unknown context '#{id}'",caller)
          end

          new_context = Context.contexts[id].new
          new_context.instance_eval(&block)

          contexts << new_context
        end

        return contexts
      end

      def Context.load_context(type,path,*args)
        type = type.to_sym

        unless Context.is_context?(type)
          raise(ContextNotFound,"unknown context '#{type}'",caller)
        end

        return Context.contexts[type].load_context(path,*args)
      end

      def Context.namify(base)
        # similar to the way Og tableizes Class names
        return base.to_s.downcase.gsub(/::/,'_').gsub(/^ronin_/,'').to_sym
      end

      protected

      def Object.contextify(id=Context.namify(self))
        id = id.to_sym

        # define context_name
        meta_def(:context_name) { id }
        class_def(:context_name) { id }

        # define self.load_context
        meta_def(:load_context) do |path,*args|
          new_obj = self.new(*args)
          new_obj.load_context(path)
          return new_obj
        end

        # define load_context
        class_def(:load_context) do |path|
          context_block = Context.load_contexts(path)[context_name]
          ronin_contexts.clear

          instance_eval(&context_block) if context_block
          return self
        end

        # define top-level context wrappers
        Kernel.module_eval %{
          def ronin_#{id}(*args,&block)
            if (args.length==0 && ronin_context_pending?)
              ronin_contexts[:#{id}] = block
              return nil
            else
              new_obj = #{self}.new(*args)
              new_obj.instance_eval(&block) if block
              return new_obj
            end
          end
        }

        # define Ronin-level context loader
        Ronin.module_eval %{
          def ronin_load_#{id}(path,*args,&block)
            new_obj = #{self}.load_context(path,*args)

            block.call(new_obj) if block
            return new_obj
          end
        }

        Context.contexts[id] = self
      end

      def Context.load_contexts(path)
        path = File.expand_path(path)

        unless File.file?(path)
          raise(ContextNotFound,"context '#{path}' doest not exist",caller)
        end

        # push on the path to load
        ronin_pending_contexts.unshift(path)

        load(path)

        # pop off the path to load
        ronin_pending_contexts.shift

        # return the loaded contexts
        return ronin_contexts
      end
    end
  end
end

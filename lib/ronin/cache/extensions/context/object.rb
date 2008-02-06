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

class Object

  protected

  def Object.contextify(id=Ronin::Cache::Context.namify(self))
    id = id.to_sym

    include Ronin::Cache::Context

    # define context_name
    meta_def(:context_name) { id }
    class_def(:context_name) { id }

    # define self.load_context
    meta_def(:load_context) do |path,*args|
      new_obj = self.new(*args)
      new_obj.load_context(path)
      return new_obj
    end

    # define load_context_block
    meta_def(:load_context_block) do |path|
      context_block = Ronin::Cache::Context.load_contexts(path)[context_name]
      ronin_contexts.clear

      return context_block
    end

    # define load_context
    class_def(:load_context) do |path|
      context_block = load_context_block(path)

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

    Ronin::Cache::Context.contexts[id] = self
  end

end

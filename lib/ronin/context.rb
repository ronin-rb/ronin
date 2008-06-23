#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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

require 'ronin/exceptions/unknown_context'
require 'ronin/exceptions/context_not_found'
require 'ronin/pending_context'
require 'ronin/extensions/meta'

module Ronin
  module Context
    def self.included(base)
      base.metaclass_eval do
        def contextify(name)
          Context.contexts[name.to_sym] = self

          meta_def(:context_name) { name }

          class_def(:context_name) { name }

          meta_def(:load_context) do |path,*args|
            Context.load_context(path,self.context_name,*args)
          end

          # define the top-level context wrappers
          Kernel.module_eval %{
            def ronin_#{name}(*args,&block)
              if (args.empty? && Ronin::Context.is_pending?)
                Ronin::Context.pending.blocks[:#{name}] = block
                return nil
              else
                new_context = #{self}.new(*args)
                new_context.instance_eval(&block) if block
                return new_context
              end
            end
          }

          # define the Ronin-level context loader
          Ronin.module_eval %{
            def ronin_load_#{name}(path,*args,&block)
              new_context = #{self}.load_context(path,*args)

              block.call(new_context) if block
              return new_context
            end
          }
        end
      end
    end

    #
    # Returns a Hash of all defined contexts.
    #
    def Context.contexts
      @@ronin_contexts ||= {}
    end

    #
    # Returns +true+ if there is a context defined with the specified
    # _name_, returns +false+ otherwise.
    #
    def Context.is_context?(name)
      Context.contexts.has_key?(name.to_sym)
    end

    #
    # Converts the name of the _base_ class to a context name, returning
    # it in +String+ form.
    #
    #   Context.namify(Ronin::Resources) # => "ronin_resources"
    #
    #   Context.namify(Analysis::Audio) # => "ronin_analysis_audio"
    #
    def Context.namify(base)
      # similar to the way Og tableizes Class names
      base.to_s.downcase.gsub(/::/,'_').gsub(/^ronin_/,'').to_sym
    end

    def Context.waiting
      @@ronin_waiting_contexts ||= []
    end

    #
    # Returns the pending context being loaded.
    #
    def Context.pending
      Context.waiting.first
    end

    #
    # Returns +true+ if there is a pending context present, returns
    # +false+ otherwise.
    #
    def Context.is_pending?
      !(Context.waiting.empty?)
    end

    #
    # Returns the first pending context with the specified _path_.
    #
    def Context.loading(path)
      Context.waiting.select { |pending|
        pending.path==path
      }.first
    end

    #
    # Returns +true+ if the pending context with the specified _path_
    # is present, returns +false+ otherwise.
    #
    def Context.is_loading?(path)
      !(Context.loading(path).nil?)
    end

    #
    # Loads all context blocks from the specified _path_, returning a
    # PendingContext object containing the context blocks.
    #
    def Context.load_blocks(path,&block)
      path = File.expand_path(path)

      unless File.file?(path)
        raise(ContextNotFound,"context #{path.dump} doest not exist",caller)
      end

      # prevent circular loading of contexts
      return Context.pending if Context.is_pending?

      # push on the new pending context
      ronin_pending_contexts.unshift(PendingContext.new(path))

      load(path)

      # pop off and return the pending context
      pending_context = ronin_pending_contexts.shift

      block.call(pending_context) if block
      return pending_context
    end

    #
    # Loads the context block of the specified _name_ from the specified
    # _path_, returning the context block. If a _block_ is given it will
    # be passed the loaded context block.
    #
    #   Context.load_block('/path/to/my_exploit.rb',:exploit) # => Proc
    #
    #   Context.load_block('/path/to/my_shellcode.rb',:shellcode)
    #     do |block|
    #     ...
    #   end
    #
    def Context.load_block(name,path,&block)
      context_block = Context.load_blocks(path).blocks[name.to_sym]

      block.call(context_block) if block
      return context_block
    end

    #
    # Loads the context of the specified _name_ and from the specified
    # _path_ with the given _args_. If no contexts were defined with the
    # specified _name_, an UnknownContext exception will be raised.
    #
    #   Context.load_context(:note,'/path/to/my_notes.rb') # => Note
    #
    def Context.load_context(name,path,*args)
      name = name.to_sym

      unless Context.is_context?(name)
        raise(UnknownContext,"unknown context '#{name}'",caller)
      end

      new_context = Context.contexts[name].new(*args)

      Context.load_block(path,name) do |context_block|
        new_context.instance_eval(&context_block) if context_block
      end

      return new_context
    end

    #
    # Loads all contexts from the specified _path_ returning an +Array+
    # of loaded contexts. If a _block_ is given, it will be passed
    # each loaded context.
    #
    #   Context.load_contexts('/path/to/misc_contexts.rb') # => [...]
    #
    def Context.load_contexts(path,&block)
      new_objs = []

      Context.load_blocks(path) do |pending|
        pending.blocks.each do |name,block|
          if Context.is_context?(name)
            new_obj = Context.contexts[name].new
            new_obj.instance_eval(&block)

            new_objs << new_obj
          end
        end
      end

      new_objs.each(&block) if block
      return new_objs
    end
  end
end

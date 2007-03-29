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

require 'code/asm/platformtarget'
require 'code/asm/type'
require 'code/asm/reg'
require 'code/asm/instruction'
require 'code/asm/label'
require 'code/asm/exceptions/redefinition'

module Ronin
  module Asm
    class Block < Type

      # Target platform
      attr_reader :target

      # Labels
      attr_reader :labels

      # Functions
      attr_reader :functions

      # Sub-Blocks
      attr_reader :blocks

      # Instructions
      attr_reader :instructions

      def initialize(target,&block)
	@target = target
	@labels = {}
	@functions = {}

	@blocks = []
	@instructions = []

	inline(&block) if block
      end

      def emit(ins)
	if ins.kind_of?(Block)
	  link(ins)
	elsif ins.kind_of?(Label)
	  emit_label(ins)
	else
	  @instructions << ins
	end
      end

      def link(block)
	if block.kind_of?(Func)
	  link_func(block)
	elsif block.kind_of?(Block)
	  @blocks << block
	  @instructions << block
	else
	  raise "cannot link in non-block", caller
	end
      end

      def emit_label(label)
	if is_restricted?(label.name)
	  raise Restricted, "cannot define label with name '#{label.name}'", caller
	end

	if @functions.has_key?(label.name)
	  raise Redefinition, "cannot redefine function '#{label.name}' as label", caller
	end

	if @labels.has_key?(label.name)
	 raise Redefinition, "cannot redefine label '#{label.name}'", caller
	end

	@labels << label
	@instructions << label
      end

      def link_func(func)
	if is_restricted?(func.name)
	  raise Restricted, "cannot define function with name '#{func.name}'", caller
	end

	if @labels.has_key?(func.name)
	  raise Redefinition, "cannot redefine label '#{func.name}' as function", caller
	end

	if @functions.has_key?(func.name)
	 raise Redefinition, "cannot redefine function '#{func.name}'", caller
	end

	@functions << func
	@instructions << func
      end

      def inline(&block)
	instance_eval(&block)
      end

      def block(&block)
	new_block = Block.new(@arch_target,&block)
	link(block)
	return new_block
      end

      def label(name)
	new_label = Label.new(name)
	emit_label(new_label)
	return new_label
      end

      def func(name,&block)
	new_func = Func.new(name,&block)
	link_func(new_func)
	return new_func
      end

      def resolve_sym(sym)
	if sym.kind_of?(Symbol)
	  new_sym = symbol(sym)

	  unless new_sym
	    raise Unresolved, "cannot resolve symbol '#{sym}'", caller
	  end
	  return new_sym
	end
	return sym
      end

      protected

      def symbol(sym)
	return @functions[sym] if @functions.has_key?(sym)
	return @labels[sym] if @labels.has_key?(sym)

	@blocks.each do |block|
	  resolved = block.symbol(sym)
	  return resolved if resolved
	end
	return nil
      end

      def is_restricted?(sym)
	return true if @target.has_reg?(sym)
	return true if @target.has_instruction?(sym)
	return true if @target.has_syscall?(sym)
	return false
      end

      def method_missing(sym,*args)
	# Resolve registers
	return @target.reg if @target.has_reg?(sym)

	# Resolve instructions
        if @target.has_instruction?(sym)
	  new_instruction = @target.instruction(sym,*args)
	  @instructions << new_instruction
	  return new_instruction
	end

	# Resolve syscalls
	return @target.syscall(sym) if @target.has_syscall?(sym)

	# Early resolution of local functions and labels
	return @functions[sym] if @functions.has_key?(sym)
	return @labels[sym] if @labels.has_key?(sym)

	# Return unknown symbol for later resolution
	return sym
      end

    end
  end
end

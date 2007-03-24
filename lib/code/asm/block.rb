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
require 'code/asm/func'
require 'code/asm/label'
require 'code/asm/exceptions/redefinition'

module Ronin
  module Asm
    class Block

      # Target architecture
      attr_reader :target

      def initialize(target,&block)
	@target = target
	@functions = {}
	@labels = {}

	@blocks = []
	@instructions = []

	inline(&block) if block
      end

      def inline(&block)
	instance_eval(&block)
      end

      def block(&block)
	new_block = Block.new(@arch_target,&block)
	@blocks << new_block
	@instructions << new_block
	return new_block
      end

      def label(name)
	if @functions.has_key?(name)
	  raise Redefinition, "cannot redefine function '#{name}' as label", caller
	end

	if @labels.has_key?(name)
	 raise Redefinition, "cannot redefine label '#{name}'", caller
	end

	new_label = Label.new(name)
	@labels[name] = new_label
	@instructions << new_label
	return new_label
      end

      def func(name,&block)
	if @labels.has_key?(name)
	  raise Redefinition, "cannot redefine function '#{name}' as label", caller
	end

	if @functions.has_key?(name)
	  raise Redefinition, "cannot redefine function '#{name}'", caller
	end

	new_func = Func.new(name,&block)
	@functions[name] = new_func
	return new_func
      end

      protected

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

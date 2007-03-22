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

require 'asm/type'
require 'asm/reg'
require 'asm/variable'
require 'asm/label'
require 'asm/instruction'
require 'asm/func'
require 'asm/exceptions/redefinition'

module Ronin
  module Asm
    class Block

      def initialize(&block)
	@functions = {}
	@labels = {}
	@variables = {}

	@blocks = []
	@instructions = []

	inline(&block) if block
      end

      def inline(&block)
	instance_eval(&block)
      end

      def emit(op,*args)
	new_inst = Instruction.new(op,*args)
	@instructions << new_inst
	return new_inst
      end

      def label(name)
	if @labels.has_key?(name)
	  raise Redefinition, "cannot redefine label '#{name}'", caller
	end

	new_label = Label.new(name)
	@labels[name] = new_label
	@instructions << new_label
	return new_label
      end

      def data(type,name,data=nil)
	if @functions.has_key?(name)
	  raise Redefinition, "cannot redefine function '#{name}' as a variable", caller
	end

	new_var = Variable.new(type,name,data)
	@variables[name] = new_var
	@instructions << new_var
	return new_var
      end

      def nop
	emit(:nop)
      end

      def mov(src,dest)
	emit(:mov,src,dest)
      end

      def add(src,dest)
	emit(:add,src,dest)
      end

      def sub(src,dest)
	emit(:sub,src,dest)
      end

      def mul(src,dest)
	emit(:mul,src,dest)
      end

      def div(src,dest)
	emit(:div,src,dest)
      end

      def and(src,dest)
	emit(:and,src,dest)
      end

      def or(src,dest)
	emit(:or,src,dest)
      end

      def xor(src,dest)
	emit(:xor,src,dest)
      end

      def cmp(data1,data2)
	emit(:cmp,data1,data2)
      end

      def jmp(dest)
	emit(:jmp,dest)
      end

      def je(dest)
	emit(:je,dest)
      end

      def jne(dest)
	emit(:jne,dest)
      end

      def jg(dest)
	emit(:jg,dest)
      end

      def jge(dest)
	emit(:jge,dest)
      end

      def jl(dest)
	emit(:jl,dest)
      end

      def jle(dest)
	emit(:jle,dest)
      end

      def jz(dest)
	emit(:jz,dest)
      end

      def jnz(dest)
	emit(:jnz,dest)
      end

      def push(src)
	emit(:push,src)
      end

      def pop(dest)
	emit(:pop,dest)
      end

      def call(dest)
	emit(:call,dest)
      end

      def ret
	emit(:ret)
      end

      def func(name,*args,&block)
	if @variables.has_key(name)
	  raise Redefinition, "cannot redefine variable '#{name}' as a function", caller
	end

	@functions[name] = Func.new(name,*args,&block)
      end

      protected

      def method_missing(sym,*args)
	emit(sym,*args)
      end

    end
  end
end

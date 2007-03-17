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
require 'asm/mov'
require 'asm/add'
require 'asm/sub'
require 'asm/mul'
require 'asm/div'
require 'asm/and'
require 'asm/or'
require 'asm/xor'
require 'asm/cmp'
require 'asm/jmp'
require 'asm/push'
require 'asm/pop'
require 'asm/call'
require 'asm/func'
require 'asm/exceptions/redefinition'

module Ronin
  module Asm
    class Block < Module

      def initialize
	@regs = Hash.new do |hash,key|
	  hash[key] = Reg.new(key)
	end

	@data = {}
	@instructions = []
	@functions = {}
      end

      def block(&block)
	new_block = Block.new
	new_block.class_eval(block)
	return new_block
      end

      def inline(block)
	@instructions << block
      end

      def asm(&block)
	inline(block(&block))
      end

      def emit(op,*args)
	@instructions << Instruction.new(op,*args)
      end

      def label(name)
	@instructions << Label.new(name)
      end

      def var(name,data)
	if @functions.has_key(name)
	  raise Redefinition, "cannot redefine function '#{name}' as a variable", caller
	end

	@instructions << Data.new(name,data.clone)
      end

      def mov(src,dest)
	@instructions << Mov.new(src,dest)
      end

      def add(src,dest)
	@instructions << Add.new(src,dest)
      end

      def sub(src,dest)
	@instructions << Sub.new(src,dest)
      end

      def mul(src,dest)
	@instructions << Mul.new(src,dest)
      end

      def div(src,dest)
	@instructions << Div.new(src,dest)
      end

      def and(src,dest)
	@instructions << And.new(src,dest)
      end

      def or(src,dest)
	@instructions << Or.new(src,dest)
      end

      def xor(src,dest)
	@instructions << Xor.new(src,dest)
      end

      def cmp(data1,data2)
	@instructions << Cmp.new(src,dest)
      end

      def jmp(dest)
	@instructions << Jmp.new(dest)
      end

      def je(dest)
	@instructions << Jmp.new(dest,Jmp::EQUALS)
      end

      def jne(dest)
	@instructions << Jmp.new(dest,Jmp::NOT_EQUALS)
      end

      def jg(dest)
	@instructions << Jmp.new(dest,Jmp::GREATER)
      end

      def jge(dest)
	@instructions << Jmp.new(dest,Jmp::GREATER_EQUALS)
      end

      def jl(dest)
	@instructions << Jmp.new(dest,Jmp::LESS)
      end

      def jle(dest)
	@instructions << Jmp.new(dest,Jmp::LESS_EQUALS)
      end

      def jz(dest)
	@instructions << Jmp.new(dest,Jmp::ZERO)
      end

      def jnz(dest)
	@instructions << Jmp.new(dest,Jmp::NOT_ZERO)
      end

      def push(src)
	@instructions << Push.new(src)
      end

      def pop(dest)
	@instructions << Pop.new(dest)
      end

      def call(dest)
	@instructions << Call.new(dest)
      end

      def ret
	@instructions << Ret.new
      end

      def func(name,*args,&block)
	if @variables.has_key(name)
	  raise Redefinition, "cannot redefine variable '#{name}' as a function", caller
	end

	@functions[name] = Func.new(name,*args,&block)
      end

      protected

      def method_missing(sym,*args)
	return @functions[sym] if @functions.has_key(sym)
	return @data[sym] if @data.has_key(sym)
	return @regs[sym]
      end

    end
  end
end

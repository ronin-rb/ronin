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

require 'code/asm/type'

module Ronin
  module Asm
    class Instruction < Type

      # The instruction opcode
      attr_reader :op

      # The arguments associated with the instruction
      attr_reader :args

      def initialize(op,*args)
	@op = op
	@args = args
      end

      def is_resolved?
	@args.each do |arg|
	  if arg.kind_of?(Symbol)
	    return false
	  elsif arg.kind_of?(Type)
	    return false unless arg.is_resolved?
	  end
	end
	return true
      end

      def resolve(block)
	unless is_resolved?
	  new_args = @args.map do |arg|
	    block.resolve_sym(arg)
	  end

	  return Instruction.new(@op,*new_args)
	end

	return self
      end

      def to_s
	unless @args.empty
	  return "#{@op}\t#{@args * ', '}"
	else
	  return "#{@op}"
	end
      end

    end
  end
end

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

require 'arch'
require 'code/asm/reg'
require 'code/asm/instruction'

module Ronin
  module Asm
    class ArchTarget

      # Target architecture
      attr_reader :arch

      # Target registers
      attr_reader :regs

      # Target instructions
      attr_reader :instructions

      def initialize(arch)
	@arch = arch
	@regs = {}
	@instructions = []
      end

      def has_reg?(sym)
	@regs.has_key?(sym)
      end

      def reg(sym)
	@regs[sym]
      end

      def has_instruction?(op)
	@instructions.include?(op)
      end

      def instruction(op,*args)
	Instruction.new(op,*args)
      end

    end
  end
end

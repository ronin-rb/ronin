require 'arch'
require 'code/asm/reg'

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

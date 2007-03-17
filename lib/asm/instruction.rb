require 'asm/type'

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

    end
  end
end

require 'asm/instruction'

module Ronin
  module Asm
    class Jmp < Instruction

      EQUALS = 0
      NOT_EQUALS = 1
      GREATER = 2
      GREATER_EQUALS = 3
      LESS = 4
      LESS_EQUALS = 5
      ZERO = 6
      NOT_ZERO = 7

      def initialize(dest,condition=nil)
	@dest = dest
	@condition = condition
      end

    end
  end
end

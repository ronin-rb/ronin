require 'asm/instruction'

module Ronin
  module Asm
    class Mov < Instruction

      def initialize(src,dest)
	super(:mov,src,dest)
      end

    end
  end
end

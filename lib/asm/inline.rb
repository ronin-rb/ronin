require 'asm/macro'

module Ronin
  module Asm
    class Inline < Macro

      # The block to inline
      attr_reader :block

      def initialize(block)
	@block = block
      end

    end
  end
end

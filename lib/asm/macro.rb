require 'asm/type'
require 'asm/block'

module Ronin
  module Asm
    class Macro < Type

      # Name of the macro
      attr_reader :name

      # Block that the macro shall operate upon
      attr_reader :block

      def initialize(name,&block)
	@name = name
	@block = Block.block(&block)
      end

    end
  end
end

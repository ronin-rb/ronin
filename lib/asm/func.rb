require 'asm/type'
require 'asm/block'

module Ronin
  module Asm
    class Func < Type

      # Name of the function
      attr_reader :name

      # Arguments of the function
      attr_reader :args

      # Block associated with the function name
      attr_reader :block

      def initialize(name,*args,&block)
	@name = name
	@args = args
	@block = Block.block(&block)
      end

    end
  end
end

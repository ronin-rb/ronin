require 'asm/instruction'

module Ronin
  module Asm
    class Label < Type

      # The name of the label
      attr_reader :name

      def initialize(name)
	@name = name
      end

    end
  end
end

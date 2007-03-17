require 'asm/type'

module Ronin
  module Asm
    class Variable < Type

      # Name of the variable
      attr_reader :name

      # Variable's data
      attr_reader :data

      def initialize(name,data=nil)
	@name = name
	@data = data
      end

    end
  end
end

require 'code/datatype'

module Ronin
  module Code
    class Struct < DataType

      # Name of the structure
      attr_reader :name

      def initialize(name)
	super(:struct)
	@name = name
      end

    end
  end
end

require 'code/datatype'
require 'code/group'

module Ronin
  module Code
    class Union < DataType

      include Group

      # Name of the union
      attr_reader :name

      def initialize(name)
	super(:union)
	@name = name
      end

    end
  end
end

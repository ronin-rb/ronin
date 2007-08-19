require 'ronin/code/datatype'
require 'ronin/code/datablock'

module Ronin
  module Code
    class Union < DataType

      # Name of the union
      attr_reader :name

      # Data block of the union
      attr_reader :data

      def initialize(name,&block)
        super(:union)
        @name = name
        @data = DataBlock.new(&block)
      end

    end

    def union(name)
      Union.new(name)
    end
  end
end

require 'ronin/code/datatype'
require 'ronin/code/datablock'

module Ronin
  module Code
    class Struct < DataType

      # Name of the structure
      attr_reader :name

      # Data block of the structure
      attr_reader :data

      def initialize(name,&block)
        super(:struct)
        @name = name
        @data = DataBlock.new(&block)
      end

      protected

      def method_missing(sym,*args)
      end

    end

    def struct(name)
      Struct.new(name)
    end

  end
end

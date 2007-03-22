module Ronin
  module Code
    class DataType

      CHAR = DataType.new(:char)
      INT = DataType.new(:int)
      INT8 = DataType.new(:int8,1)
      INT16 = DataType.new(:int16,2)
      INT32 = DataType.new(:int32,4)
      INT64 = DataType.new(:int64,8)
      STRING = DataType.new(:string)

      # Name of data-type
      attr_reader :type

      # Size of data-type
      attr_reader :size

      def initialize(type,size=0)
	@type = type
	@size = size
      end

    end
  end
end

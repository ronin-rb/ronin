module Ronin
  module Code
    class DataType

      CHAR = DataType.new(:char)
      INT = DataType.new(:int)
      INT8 = DataType.new(:int8)
      INT16 = DataType.new(:int16)
      INT32 = DataType.new(:int32)
      INT64 = DataType.new(:int64)
      STRING = DataType.new(:string)
      POINTER = DataType.new(:pointer)

      # Name of data-type
      attr_reader :type

      # Size of data-type
      attr_reader :size

      def initialize(type,size=0)
	@type = type
	@size = size
      end

    end

    def char
      DataType::CHAR
    end

    def int
      DataType::INT
    end

    def int8
      DataType::INT8
    end

    def int16
      DataType::INT16
    end

    def int32
      DataType::INT32
    end

    def int64
      DataType::INT64
    end

    def string
      DataType::STRING
    end

    def pointer
      DataType::POINTER
    end
  end
end

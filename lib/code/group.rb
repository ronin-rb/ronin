module Ronin
  module Code
    module Group

      def char(name)
	DataType.CHAR
      end

      def int(name)
	DataType.INT
      end

      def int8(name)
	DataType.INT8
      end
      
      def int16(name)
	DataType.INT16
      end
      
      def int32(name)
	DataType.INT32
      end

      def int64(name)
	DataType.INT64
      end

      def string(name)
	DataType.STRING
      end

      def pointer(name)
	Pointer.new(name)
      end

      def struct(name)
	Struct.new(name)
      end

      def union(name)
	Union.new(name)
      end

      protected

      def method_missing(sym,*args)
      end
    end
  end
end

require 'code/datatype'
require 'code/variable'
require 'code/struct'
require 'code/union'

module Ronin
  module Code
    class DataBlock

      # Members of the group
      attr_reader :members

      def initialize(&block)
	@members = {}
	instance_eval(&block) if block
      end

      def char(name)
	add_member(DataType::CHAR,name)
      end

      def int(name)
	add_member(DataType::INT,name)
      end

      def int8(name)
	add_member(DataType::INT8,name)
      end
      
      def int16(name)
	add_member(DataType::INT16,name)
      end
      
      def int32(name)
	add_member(DataType::INT32,name)
      end

      def int64(name)
	add_member(DataType::INT64,name)
      end

      def string(name)
	add_member(DataType::STRING,name)
      end

      def pointer(name)
	add_member(DataType::POINTER,name)
      end

      def struct(type,name=nil)
	@members[name] = Variable.new(Struct.new(type),name)
      end

      def union(type,name=nil)
	@members[name] = Variable.new(Union.new(type),name)
      end

      def add_member(type,name=nil)
	@members[name] = Variable.new(type,name)
      end

      protected

      def method_missing(sym,*args)
	add_member(sym,args)
      end
    end

    def data(&block)
      DataBlock.new(&block)
    end

  end
end

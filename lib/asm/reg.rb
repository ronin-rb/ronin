require 'asm/type'
require 'asm/immed'

module Ronin
  module Asm
    class Reg < Type

      # The register index
      attr_reader :id

      def initialize(id)
	@id = id
      end

      def +(disp)
	Immed.new(self,disp)
      end

      def *(scale)
	Immed.new(self,1,scale)
      end

      def [](index,scale)
	Immed.new(self,index,scale)
      end

      def to_s
	@id.id2name
      end

    end
  end
end

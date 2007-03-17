require 'asm/type'

module Ronin
  module Asm
    class Immed < Type

      # Base
      attr_reader :base

      # Index
      attr_reader :index

      # Scale
      attr_reader :scale

      def initialize(base,index=0,scale=0)
	@base = base
	@index = index
	@scale = scale
      end

      def +(disp)
	Immed.new(self,disp)
      end

    end
  end
end

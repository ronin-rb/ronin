require 'code/sql/expr'

module Ronin
  module Code
    module SQL
      class Aggregate < Expr

	def initialize(func,*fields)
	  @func = func
	  @fields = fields
	end

	def compile
	  super(negated?,"#{@func}(#{format_list(@fields)})")
	end

      end
    end
  end
end

require 'code/sql/expr'

module Ronin
  module Code
    module SQL
      class Between < Expr

	def initialize(expr,lower,higher)
	  super('BETWEEN')

	  @expr = expr
	  @lower = lower
	  @higher = higher
	end

	def compile(dialect=nil)
	  format_expr(@expr,negated?,'BETWEEN',@lower,'AND',@higher)
	end

      end
    end
  end
end

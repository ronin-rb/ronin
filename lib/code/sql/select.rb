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
      class Select < Statement

	option_list :rows, [:all, :distinct]

	def initialize(style,tables=nil,opts={:fields => [], :from => nil, :where => nil},&block)
	  @tables = tables
	  @fields = opts[:fields]
	  @from = opts[:from]
	  @where = opts[:where]

	  super(style,&block)
	end

	def fields(*exprs)
	  @fields = exprs
	end

	def from(*tables)
	  @tables = tables
	end

	def where(expr)
	  @where = expr
	end

	def order_by(*exprs)
	  @order_by = exprs
	end

	def union(expr)
	  @union = expr
	end

	def union_all(expr)
	  @union_all = expr
	end

	def join(table,on_expr)
	  @join_type = :outer
	  @join_table = table
	  @join_on = on_expr
	end

	def inner_join(table,on_expr)
	  @join_type = :inner
	  @join_table = table
	  @join_on = on_expr
	end

	def left_join(table,on_expr)
	  @join_type = :left
	  @join_table = table
	  @join_on = on_expr
	end

	def right_join(table,on_expr)
	  @join_type = :right
	  @join_table = table
	  @join_on = on_expr
	end

	def compile
	  compile_expr('SELECT',rows?,fields?,'FROM',compile_list(@tables),where?,unioned?)
	end

	protected

	def fields?
	  if @fields.kind_of?(Array)
	    unless @fields.empty?
	      return compile_group(@fields)
	    else
	      return '*'
	    end
	  else
	    return @fields.to_s
	  end
	end

	def where?
	  return "WHERE #{@where}" if @where
	end

	def unioned?
	  if @union_all
	    return "UNION ALL #{@union_all}"
	  elsif @union
	    return "UNION #{@union}"
	  end
	end

      end
    end
  end
end

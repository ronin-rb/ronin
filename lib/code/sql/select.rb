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

	def initialize(style,tables=nil,opts={:fields => nil, :where => nil},&block)
	  @fields = opts[:fields] || all_fields
	  @tables = tables
	  @where = opts[:where]

	  super(style,&block)
	end

	def fields(*exprs)
	  @fields = exprs
	  return self
	end

	def tables(expr)
	  @table = expr
	  return self
	end

	def where(expr)
	  @where = expr
	  return self
	end

	def order_by(*exprs)
	  @order_by = exprs
	  return self
	end

	def group_by(*fields)
	  @group_by = fields
	  return self
	end

	def having(expr)
	  @having = expr
	  return self
	end

	def union(table,opts={:fields => [], :where => nil},&block)
	  @union = Select.new(@style,table,opts,&block)
	  return self
	end

	def union_all(table,opts={:fields => [], :where => nil},&block)
	  @union_all = Select.new(@style,table,opts,&block)
	  return self
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
	  compile_expr(keyword_select,rows?,fields?,keyword_from,compile_list(@tables),where?,order_by?,group_by?,unioned?)
	end

	protected

	keyword :select
	keyword :from
	keyword :where
	keyword :union
	keyword :union_all
	keyword :order_by, 'ORDER BY'
	keyword :group_by, 'GROUP BY'
	keyword :having

	def fields?
	  if @fields.kind_of?(Array)
	    unless @fields.empty?
	      return compile_row(@fields)
	    else
	      return all_fields.to_s
	    end
	  else
	    return @fields.to_s
	  end
	end

	def where?
	  compile_expr(keyword_where,@where) if @where
	end

	def order_by?
	  compile_expr(keyword_order_by,@order_by) if @order_by
	end

	def having?
	  compile_expr(keyword_having,@having) if @having
	end

	def group_by?
	  compile_expr(keyword_group_by,compile_row(@group_by),having?) if @group_by
	end

	def unioned?
	  if @union_all
	    return compile_expr(keyword_union_all,@union_all)
	  elsif @union
	    return compile_expr(keyword_union,@union)
	  end
	end

      end
    end
  end
end

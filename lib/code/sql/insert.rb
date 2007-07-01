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
      class Insert < Statement

	def initialize(style,table=nil,opts={:fields => [], :values => nil, :from => nil},&block)
	  @table = table
	  @fields = opts[:fields]
	  @values = opts[:values]
	  @from = opts[:from]

	  super(style,&block)
	end

	def into(table)
	  @table = table
	end

	def fields(*fields)
	  @fields = fields
	end

	def values(*values)
	  if (@values.length==1 && @values[0].kind_of?(Hash))
	    @values = values[0]
	  else
	    @values = values
	  end
	end

	def from(expr)
	  @from = expr
	end

	def compile
	  if @values.kind_of?(Hash)
	    return compile_expr('INSERT INTO',@table,compile_group(@values.keys),'VALUES',compile_datalist(@values.values))
	  elsif @from
	    return compile_expr('INSERT INTO',@table,compile_group(@fields),@from)
	  else
	    if @fields
	      return compile_expr('INSERT INTO',@table,compile_group(@fields),'VALUES',compile_datalist(@values))
	    else
	      return compile_expr('INSERT INTO',@table,'VALUES',compile_datalist(@values))
	    end
	  end
	end

      end
    end
  end
end

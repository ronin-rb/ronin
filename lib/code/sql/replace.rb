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
      class Replace < Statement

	def initialize(style,table=nil,values=nil,from=nil,&block)
	  @table = table
	  @values = values
	  @from = from

	  super(style,&block)
	end

	def values(data)
	  @values = data
	end

	def from(expr)
	  @from = expr
	end

	def compile
	  if @values.kind_of?(Hash)
	    return compile_expr('REPLACE INTO',@table,compile_list(@values.keys),'VALUES',compile_datalist(@values.values))
	  elsif @from.kind_of?(Select)
	    return compile_expr('REPLACE INTO',@table,compile_list(@values),@from)
	  end
	end

      end
    end
  end
end

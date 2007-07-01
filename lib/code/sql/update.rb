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
      class Update < Statement

	def initialize(style,table=nil,set_data={},where_expr=nil,&block)
	  @table = table
	  @set_data = set_data
	  @where_expr = where_expr

	  super(style,&block)
	end

	def table(value)
	  @table = value
	end

	def set(data)
	  @set_data = data
	end

	def where(expr)
	  @where_expr = expr
	end

	def compile
	  set_values = "SET "+@set_data.map { |name,value|
	    "#{name} = #{quote_string(value)}"
	  }.join(', ')

	  return compile_expr('UPDATE',@table,set_values,where?)
	end

	protected

	def where?
	  "WHERE #{@where_expr}" if @where_expr
	end

      end
    end
  end
end

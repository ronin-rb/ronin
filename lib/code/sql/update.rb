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

require 'code/sql/command'

module Ronin
  module Code
    module SQL
      class Update < Command

	def initialize(table=nil,set_data={},where_expr=nil,&block)
	  @table = table
	  @set_data = set_data
	  @where_expr = where_expr

	  super("UPDATE",&block)
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

	def compile(dialect=nil,multiline=false)
	  set_values = "SET "+@set_data.map { |name,value|
	    "#{name} = #{quote_data(value)}"
	  }.join(', ')

	  if @where_expr
	    return "UPDATE #{table} #{set_values} WHERE #{where_expr}"
	  else
	    return "UPDATE #{table} #{set_values}"
	  end
	end

      end
    end
  end
end

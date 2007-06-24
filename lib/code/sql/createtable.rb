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
      class CreateTable < Command

	flag :temp
	
	option :if_not_exists, "IF NOT EXISTS"
	option :or_replace, "OR REPLACE"

	def initialize(table=nil,columns={},not_null={},&block)
	  @table = table
	  @columns = columns
	  @not_null = not_null

	  super("CREATE",&block)
	end

	def column(name,type,null=false)
	  name = name.to_s
	  @columns[name] = type.to_s
	  @not_null[name] = null
	end

	def compile(dialect=nil,multiline=false)
	  format_columns = lambda {
	    @columns.map { |name,type|
	      if @not_null[name]
	        "#{name} #{type} NOT NULL"
	      else
	        "#{name} #{type}"
	      end
	    }
	  }

	  return super(or_replace?,"TABLE",@table,format_set(format_columns.call))
	end

      end
    end
  end
end

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
      class CreateIndex < Statement

	option :unqiue, "UNIQUE"
	option :if_not_exists, "IF NOT EXISTS"

	def initialize(style,index=nil,table=nil,columns={},&block)
	  @index = index
	  @table = table
	  @columns = columns

	  super(style,&block)
	end

	def index(field)
	  @index = field
	  return self
	end

	def table(field)
	  @table = field
	  return self
	end

	def column(name,type)
	  @columns[name.to_s] = type.to_s
	  return self
	end

	def compile(dialect=nil,multiline=false)
	  format_columns = lambda {
	    @columns.map { |name,type|
	      "#{name} #{type}"
	    }
	  }

	  return compile_expr(keyword_create,unique?,keyword_index,if_not_exists?,@index,keyword_on,@table,compile_row(format_columns.call))
	end

	protected

	keyword :create
	keyword :index
	keyword :on

      end
    end
  end
end

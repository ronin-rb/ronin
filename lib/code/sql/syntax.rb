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

require 'code/sql/fieldable'

module Ronin
  module Code
    module SQL
      module Syntax
	include Fieldable

	def dialect(lang)
	  @dialect = lang.to_s
	end

	def dialect?
	  @dialect
	end

	def sql_and(*expr)
	  expr.join(' AND ')
	end

	def sql_or(*expr)
	  expr.join(' OR ')
	end	

	def count(fields=[])
	  Aggregate.new(:count,fields)
	end

	def sum(fields=[])
	  Aggregate.new(:sum,fields)
	end

	def avg(fields=[])
	  Aggregate.new(:avg,fields)
	end

	def create_table(table=nil,columns={},not_null={},&block)
	  CreateTable.new(table,columns,not_null,&block)
	end

	def insert(table=nil,opts={:fields => [], :values => nil, :from => nil},&block)
	  Insert.new(table,opts,&block)
	end

	def select(tables=nil,opts={:fields => [], :from => nil, :where => nil},&block)
	  Select.new(tables,opts,&block)
	end

	def update(table=nil,set_data={},where_expr=nil,&block)
	  Update.new(table,set_data,where_expr,&block)
	end

	def delete(table=nil,where_expr=nil,&block)
	  Delete.new(table,where_expr,&block)
	end

	def drop_table(table=nil,&block)
	  DropTable.new(table,&block)
	end
      end
    end
  end
end

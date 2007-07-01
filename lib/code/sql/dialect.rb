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

require 'code/sql/createtable'
require 'code/sql/insert'
require 'code/sql/select'
require 'code/sql/update'
require 'code/sql/delete'
require 'code/sql/droptable'
require 'code/sql/exceptions/unknowndialect'

module Ronin
  module Code
    module SQL
      class Dialect

	def create_table(style,table=nil,columns={},not_null={},&block)
	  CreateTable.new(style,table,columns,not_null,&block)
	end

	def insert(style,table=nil,opts={:fields => [], :values => nil, :from => nil},&block)
	  Insert.new(style,table,opts,&block)
	end

	def select_from(style,tables=nil,opts={:fields => [], :from => nil, :where => nil},&block)
	  Select.new(style,tables,opts,&block)
	end

	def update(style,table=nil,set_data={},where_expr=nil,&block)
	  Update.new(style,table,set_data,where_expr,&block)
	end

	def delete(style,table=nil,where_expr=nil,&block)
	  Delete.new(style,style,table,where_expr,&block)
	end

	def drop_table(style,table=nil,&block)
	  DropTable.new(style,table,&block)
	end

	protected

	def Dialect.dialects
	  @@dialects ||= {}
	end

	def Dialect.has_dialect?(name)
	  Dialect.dialects.has_key?(name.to_s)
	end

	def Dialect.get_dialect(name)
	  name = name.to_s

	  unless Dialect.has_dialect?(name)
	    raise UnknownDialect, "unknown dialect '#{name}'", caller
	  end

	  return Dialect.dialects[name].new
	end

	def Dialect.dialect(name)
	  dialects[name.to_s] = self

	  class_eval <<-end_eval
	    def to_s
	      '#{name}'
	    end
	  end_eval
	end

	dialect 'common'

	def Dialect.aggregate(*syms)
	  for sym in syms
	    class_eval <<-end_eval
	      def #{sym}(style,*fields)
	        Aggregate.new(style,:#{sym},*fields)
	      end
	    end_eval
	  end
	end

	aggregate :count, :min, :max, :sum, :avg

	def method_missing(sym,*args)
	  name = sym.id2name
	  if (dialects.has_key?(name) && args.length==0)
	    return dialects[name]
	  end

	  raise NoMethodError, name, caller
	end

      end
    end
  end
end

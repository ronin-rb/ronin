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

require 'code/sql/syntax'
require 'code/sql/field'
require 'code/sql/createtable'
require 'code/sql/insert'
require 'code/sql/select'
require 'code/sql/update'
require 'code/sql/delete'
require 'code/sql/droptable'

module Ronin
  module Code
    module SQL
      class Statement

	include Syntax

	def initialize(*cmds,&block)
	  @commands = cmds

	  instance_eval(&block) if block
	end

	def command(*cmds)
	  @commands+=cmds.flatten
	  return self
	end

	def <<(cmd)
	  @commands << cmd
	  return self
	end

	def create_table(table=nil,columns={},not_null={},&block)
	  @commands << super(table,columns,not_null,&block)
	  return @commands.last
	end

	def insert(table=nil,opts={:fields => nil, :values => nil, :from => nil},&block)
	  @commands << super(table,opts,&block)
	  return @commands.last
	end

	def select(tables=nil,opts={:fields => [], :from => nil, :where => nil},&block)
	  @commands << super(table,opts,&block)
	  return @commands.last
	end

	def update(table=nil,set_data={},where_expr=nil,&block)
	  @commands << super(table,set_data,where_expr,&block)
	  return @commands.last
	end

	def delete(table=nil,where_expr=nil,&block)
	  @commands << super(table,where_expr,&block)
	  return @commands.last
	end

	def drop_table(table=nil,&block)
	  @commands << super(table,&block)
	  return @commands.last
	end

	def compile(multiline=false)
	  sub_compile = lambda {
	    @commands.map do |cmd|
	      if cmd.kind_of?(Command)
		cmd.compile(@dialect,multiline)
	      else
		cmd.to_s
	      end
	    end
	  }

	  if multiline
	    return sub_compile.call.join("\n")
	  else
	    return sub_compile.call.join('; ')
	  end
	end

	def Statement.compile(multiline=false,&block)
	  Statement.new(&block).compile(multiline)
	end

	def to_s
	  compile
	end

      end
    end
  end
end

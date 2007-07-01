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
      class Program < Statement

	def initialize(cmds=[],style=Style.new,&block)
	  @commands = cmds.flatten

	  super(style,&block)
	end

	def command(*cmds,&block)
	  @commands+=cmds.flatten

	  instance_eval(&block) if block
	  return self
	end

	def <<(cmd)
	  @commands << cmd
	  return self
	end

	def compile
	  if multiline?
	    return @commands.join("\n")
	  else
	    return @commands.join('; ')
	  end
	end

	def Program.compile(*cmds,&block)
	  Program.new(*cmds,&block).compile
	end

	protected

	def method_missing(sym,*args,&block)
	  name = sym.id2name

	  if @style.expresses?(name)
	    result = @style.express(name,*args,&block)

	    @commands << result if result.kind_of?(Command)
	    return result
	  end

	  return super(sym,*args,&block)
	end

      end
    end
  end
end

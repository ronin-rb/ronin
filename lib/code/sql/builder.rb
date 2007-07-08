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
require 'code/sql/style'

module Ronin
  module Code
    module SQL
      class Builder < Statement

	# Style of the program
	attr_reader :style

	def initialize(cmds=[],style=Style.new,&block)
	  @commands = cmds.flatten

	  super(style,&block)
	end

	def dialect(name)
	  @style.set_dialect(name)
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

	def to_s
	  if @style.multiline
	    return compile_lines(@commands)
	  else
	    return compile_lines(@commands,append_space(';'))
	  end
	end

	def respond_to?(sym)
	  return true if @style.expresses?(sym)
	  return super(sym)
	end

	protected

	def method_missing(sym,*args,&block)
	  name = sym.id2name

	  if @style.expresses?(name)
	    result = @style.express(name,*args,&block)

	    @commands << result if result.kind_of?(Statement)
	    return result
	  end

	  return super(sym,*args,&block)
	end

      end
    end
  end
end

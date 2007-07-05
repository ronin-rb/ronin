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

require 'code/sql/expr'

module Ronin
  module Code
    module SQL
      class LikeExpr < Expr

	def initialize(style,op,left,right,escape=nil)
	  super(style)

	  @op = op
	  @left = left
	  @right = right
	  @escape = escape
	  @negated = false
	end

	def escape(str)
	  @escape = str
	end

	def not!
	  @negated = true
	end

	def compile
	  compile_expr(@left,negated?,@op,compile_pattern(@right),escaped?)
	end

	protected

	keyword :escape
	keyword :not

	def escape_pattern(pattern)
	  pattern = pattern.to_s

	  if @escape
	    return quote_data(pattern)
	  else
	    return quote_data("%#{pattern}%")
	  end
	end

	def compile_pattern(pattern)
	  if pattern.kind_of?(Regexp)
	    return escape_pattern(pattern.source)
	  else
	    return escape_pattern(pattern)
	  end
	end

	def escaped?
	  compile_expr(keyword_escape,"'#{@escape.to_s[0..0]}'") if @escape
	end

	def negated?
	  keyword_not if @negated
	end

      end
    end
  end
end

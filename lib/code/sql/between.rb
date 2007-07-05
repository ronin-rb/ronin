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
      class Between < Expr

	def initialize(expr,lower,higher)
	  super()

	  @expr = expr
	  @lower = lower
	  @higher = higher
	  @negated = false
	end

	def not!
	  @negated = true
	  return self
	end

	def compile
	  compile_expr(@expr,negated?,keyword_between,@lower,keyword_and,@higher)
	end

	protected

	keyword :between
	keyword :and
	keyword :not

	def negated?
	  keyword_not if @negated
	end

      end
    end
  end
end

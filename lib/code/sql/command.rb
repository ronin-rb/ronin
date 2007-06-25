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

require 'code/codeable'
require 'code/sql/syntax'
require 'code/sql/field'
require 'code/sql/expressable'
require 'code/sql/formating'
require 'code/sql/binaryexpr'
require 'code/sql/unaryexpr'
require 'code/sql/likeexpr'
require 'code/sql/aggregate'

module Ronin
  module Code
    module SQL
      class Command

	include Codeable
	include Syntax
	include Expressable
	include Formating

	def initialize(name,&block)
	  @name = name

	  instance_eval(&block) if block
	end

	def compile(*args)
	  [@name,*args].compact.join(' ')
	end

	def to_s
	  compile
	end

	protected

	def format_list(*expr)
	  expr.join(', ')
	end

	def format_set(expr)
	  if expr.length==1
	    return expr.to_s
	  else
	    return "(#{format_list(expr)})"
	  end
	end

	def format_datalist(*expr)
	  return format_set( expr.flatten.map { |value| format_data(value) } )
	end

      end
    end
  end
end

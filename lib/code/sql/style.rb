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

require 'code/sql/dialect'

module Ronin
  module Code
    module SQL
      class Style

	# Dialect to use
	attr_reader :dialect

	# Use single-line or multi-line style
	attr_accessor :multiline

	# Use lowercase style
	attr_accessor :lowercase

	def initialize(dialect=Dialect)
	  @dialect = dialect
	  @multiline = true
	  @lowercase = false
	end

	def set_dialect(value)
	  if value.kind_of?(String)
	    return @dialect = Dialect.get_dialect(value)
	  elsif value.kind_of?(Dialect)
	    return @dialect = value
	  end
	end

	def expresses?(sym)
	  @dialect.respond_to?(sym)
	end

	def express(sym,*args,&block)
	  @dialect.send(sym,self,*args,&block)
	end

      end
    end
  end
end

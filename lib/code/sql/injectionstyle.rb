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

require 'code/sql/style'

module Ronin
  module Code
    module SQL
      class InjectionStyle < Style

	# Comment-Obfusticate all keywords
	attr_accessor :comment_evasion

	# Swapcase-Obfusciate all keywords
	attr_accessor :swapcase_evasion

	def initialize(dialect=Dialect.new)
	  super(dialect)

	  @comment_keywords = false
	  @swapcase_keywords = false
	end

	def compile_keyword(name)
	  name = name.to_s

	  if (name.length && (@comment_evasion || @swapcase_evasion))

	    if @swapcase_evasion
	      for i in rand(name.length-1)
		name[i] = name[i..i].swapcase
	      end
	    end

	    if (name.length>1 && @command_evasion)
	      name = name.insert(rand(name.length-2)+1,'/**/')
	    end

	    return name
	  else
	    return super(name)
	  end
	end

      end
    end
  end
end

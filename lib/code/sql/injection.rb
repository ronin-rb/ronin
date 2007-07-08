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

require 'code/sql/program'
require 'code/sql/injectionstyle'
require 'code/sql/injectionbuilder'
require 'extensions/string'

module Ronin
  module Code
    module SQL
      class Injection < Program

	def initialize(expr=[],style=InjectionStyle.new,&block)
	  @style = style
	  @builder = InjectionBuilder.new(expr,style,&block)
	end

	def compile
	  @builder.to_s
	end

	def to_s
	  compile
	end

	def Injection.compile(*expr,&block)
	  Injection.new(expr,&block).compile
	end

	def url_encode
	  compile.url_encode
	end

	def Injection.url_encode(*expr,&block)
	  Injection.new(expr,&block).url_encode
	end

	def html_hex
	  compile.html_hex_encode
	end

	def Injection.html_hex(*expr,&block)
	  Injection.new(expr,&block).html_hex
	end

	def html_dec
	  compile.html_dec_encode
	end

	def Injection.html_dec(*expr,&block)
	  Injection.new(expr,&block).html_dec
	end

	def base64
	  compile.base64_encode
	end

	def Injection.base64(*expr,&block)
	  Injection.new(expr,&block).base64
	end

      end
    end
  end
end

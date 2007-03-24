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

require 'code/exceptions/dereference'

module Ronin
  module Code
    class Variable

      # Type of the variable
      attr_reader :type

      # Name of the variable
      attr_reader :name

      # Variable's value
      attr_reader :value

      def initialize(type,name,value=nil)
	@type = type
	@name = name

	if value
	  @value = value.clone
	else
	  @value = nil
	end
      end

      def =(value)
	@value = value
      end

      def addr
	Ref.new(self)
      end

      def data
	unless @type==DataType.POINTER
	  raise Dereference, "cannot dereference non-pointer data '#{@name}'", caller
	end

	return Deref.new(self)
      end

      def method_missing(sym,*args)
	Variable.new(@type,@name,@value.send(sym,args)) if @data
      end

    end
  end
end

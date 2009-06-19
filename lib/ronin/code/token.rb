#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/code/emittable'

module Ronin
  module Code
    class Token
      
      include Emittable

      # Value of the token
      attr_reader :value

      #
      # Creates a new Token object with the specified _value_.
      #
      def initialize(value)
        @value = value
      end

      #
      # Emits the token.
      #
      def emit
        [self]
      end

      #
      # Returns +true+ if the token has the same value as the specified
      # _other_ token, returns +false+ otherwise.
      #
      def ==(other)
        self.value == other.value
      end

      #
      # Inspects the token.
      #
      def inspect
        "#<#{self.class}: #{@value.inspect}>"
      end

      #
      # Returns the String form of the token.
      #
      def to_s
        @value.to_s
      end
    end
  end
end

#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module Platform
    class Maintainer

      # Name of the maintainer
      attr_reader :name

      # Email of the maintainer
      attr_reader :email

      #
      # Creates a new Maintainer object.
      #
      # @param [String] name
      #   The name of the maintainer.
      #
      # @param [String] email
      #   The optional email of the maintainer.
      #
      def initialize(name,email=nil)
        @name = name
        @email = email
      end

      #
      # @return [String]
      #   The String representation of the maintainer object.
      #
      def to_s
        if @email
          return "#{@name} <#{@email}>"
        else
          return @name.to_s
        end
      end

      #
      # @return [String]
      #   Inspects the maintainer object.
      #
      # @see Maintainer#to_s
      #
      def inspect
        "#<#{self.class.name}: #{self}>"
      end

    end
  end
end

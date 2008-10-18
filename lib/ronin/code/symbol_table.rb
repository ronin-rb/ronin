#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/code/reference'

module Ronin
  module Code
    class SymbolTable

      #
      # Creates a new SymbolTable object.
      #
      def initialize(symbols={})
        @table = Hash.new do |hash,key|
          hash[key] = Reference.new
        end

        symbols.each do |name,value|
          self[name] = value
        end
      end

      #
      # Returns +true+ if the table has the symbol with the specified
      # _name_, returns +false+ otherwise.
      #
      def has_symbol?(name)
        @table.has_key?(name.to_s)
      end

      #
      # Returns the symbol with the specified _name_.
      #
      def symbol(name)
        @table[name.to_s]
      end

      #
      # Returns the value of the symbol with the specified _name_.
      #
      def [](name)
        @table[name.to_s].value
      end

      #
      # Sets the _value_ of the symbol with the specified _name_.
      #
      def []=(name,value)
        @table[name.to_s].value = value
      end

      #
      # Inspects the symbol table.
      #
      def inspect
        '{' + @table.map { |name,symbol|
          "#{name.inspect}=>#{symbol.inspect}"
        }.join(', ') + '}'
      end

    end
  end
end

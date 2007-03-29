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

module Ronin
  module Code
    class CodeTarget

      # Name
      attr_reader :name

      # Ro location
      attr_reader :ro

      # Data location
      attr_reader :data

      # Text location
      attr_reader :text

      # Variables
      attr_reader :variables

      # Functions
      attr_reader :funcs

      def initialize(name,ro,data,text,variables={},funcs={})
	@name = name
	@ro = ro
	@data = data
	@text = text
	@variables = variables
	@funcs = funcs
      end

      def has_variable?(sym)
	@variables.has_key?(sym)
      end

      def variable(sym)
	@variables[sym]
      end

      def has_function?(sym)
	@funcs.has_key?(sym)
      end

      def function(sym)
	@funcs[sym]
      end

    end
  end
end

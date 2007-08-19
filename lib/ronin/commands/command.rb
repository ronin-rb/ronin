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
  module Commands
    class Command

      # Official name of the command
      attr_reader :name

      # Other short names of the command
      attr_reader :short_names

      # Command block
      attr_reader :block

      def initialize(name,*short_names,&block)
        @name = name
        @short_names = short_names
        @block = block
      end

      def run(argv)
        @block.call(argv)
      end

      def to_s
        str = @name
        unless @short_names.empty?
          str+=" "+@short_names.join(', ')
        end
        return str
      end

    end
  end
end

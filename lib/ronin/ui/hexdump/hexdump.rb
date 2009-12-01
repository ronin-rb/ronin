#
# Ronin - A Ruby platform for exploit development and security research.
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
#

module Ronin
  module UI
    module Hexdump
      #
      # Hexdumps an object.
      #
      # @param [#each_byte] object
      #   The object to hexdump, must respond to the +each_byte+ method.
      #
      # @param [IO] output
      #   The output stream to print the hexdump to.
      #
      # @return [nil]
      #
      def Hexdump.dump(object,output=STDOUT)
        index = 0
        offset = 0
        hex_segment = nil
        print_segment = nil

        segment = lambda {
          output.printf(
            "%.8x  %s  |%s|\n",
            index,
            hex_segment.join(' ').ljust(47).insert(23,' '),
            print_segment
          )
        }

        object.each_byte do |b|
          if offset == 0
            hex_segment = []
            print_segment = []
          end

          hex_segment << ("%.2x" % b)

          print_segment[offset] = case b
                                  when (0x20..0x7e)
                                    b.chr
                                  else
                                    '.'
                                  end

          offset += 1

          if (offset >= 16)
            segment.call

            offset = 0
            index += 16
          end
        end

        unless offset == 0
          segment.call
        end

        return nil
      end
    end
  end
end

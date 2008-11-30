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

require 'ronin/translators/translator'

module Ronin
  module Translators
    class WhiteSpace < Translator

      # The set of characters to use for the white-space encoding
      ALPHABET = ["\r", "\n", "\t", ' ']

      # The start-character
      START_CHAR = "\n"

      #
      # Encodes the specified _data_ as white-space encoded data. If a
      # _block_ is given, it will be passed the white-space encoded data.
      #
      #   translator.encode("\x00\x90")
      #   # => "\n\r                                                \r"
      #
      def encode(data,&block)
        space = ''
        space << START_CHAR

        data.each_byte do |b|
          space << (ALPHABET.last * (b / (ALPHABET.length - 1)))
          space << ALPHABET[b % (ALPHABET.length - 1)]
        end

        block.call(space) if block
        return space
      end

      #
      # Decodes the specified white-space encoded _text_. If a _block_ is
      # given, it will be passed the decoded data.
      #
      #   translator.decode("\n\r\n\t \r \n \t")
      #   # => "\000\001\002\003\004\005"
      #
      def decode(text,&block)
        start_index = text.index(START_CHAR)
        next_byte = 0
        data = ''

        text[(start_index + 1)..-1].each_byte do |b|
          c = b.chr

          if c == ALPHABET.last
            next_byte += (ALPHABET.length - 1)
          elsif ALPHABET.include?(c)
            next_byte += ALPHABET.index(c)

            data << next_byte.chr
            next_byte = 0
          else
            break
          end
        end

        block.call(data) if block
        return data
      end

    end
  end
end

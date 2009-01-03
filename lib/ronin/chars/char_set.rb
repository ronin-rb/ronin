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

require 'set'

module Ronin
  module Chars
    class CharSet < SortedSet

      #
      # Creates a new CharSet object with the given _chars_.
      #
      def initialize(*chars)
        super()

        merge_chars = lambda { |element|
          if element.kind_of?(String)
            element.each_byte(&merge_chars)
          elsif element.kind_of?(Integer)
            self << element
          elsif element.kind_of?(Enumerable)
            element.each(&merge_chars)
          end
        }

        merge_chars.call(chars)
      end

      alias include_byte? include?
      alias bytes to_a
      alias each_byte each
      alias select_bytes select
      alias map_bytes map

      #
      # Returns +true+ if the character set includes the specified _char_,
      # returns +false+ otherwise.
      #
      def include_char?(char)
        char.each_byte do |b|
          return include?(b)
        end
      end

      #
      # Returns all the characters within the character set as Strings.
      #
      def chars
        map { |b| b.chr }
      end

      #
      # Iterates over every character within the character set, passing
      # each to the given _block_.
      #
      def each_char(&block)
        each { |b| block.call(b.chr) } if block
      end

      #
      # Selects an Array of characters from the character set that match
      # the given _block_.
      #
      def select_chars(&block)
        chars.select(&block)
      end

      #
      # Maps the characters of the character set using the given _block_.
      #
      def map_chars(&block)
        chars.map(&block)
      end

      #
      # Returns a random byte from the character set.
      #
      def random_byte
        self.entries[rand(self.length)]
      end

      #
      # Returns a random char from the character set.
      #
      def random_char
        random_byte.chr
      end

      #
      # Pass a random byte to the specified _block_, _n_ times.
      #
      def each_random_byte(n,&block)
        n.times { block.call(random_byte) }
      end

      #
      # Pass a random character to the specified _block_, _n_ times.
      #
      def each_random_char(n,&block)
        each_random_byte(n) { |b| block.call(b.chr) }
      end

      #
      # Returns an Array of the specified _length_ containing
      # random bytes from the character set. The specified _length_ may
      # be an Integer, Array or a Range of lengths.
      #
      def random_bytes(length)
        if (length.kind_of?(Array) || length.kind_of?(Range))
          return Array.new(length.sort_by { rand }.first) { random_byte }
        else
          return Array.new(length) { random_byte }
        end
      end

      #
      # Returns an Array of the specified _length_ containing
      # random characters from the character set. The specified _length_
      # may be an Integer, Array or a Range of lengths.
      #
      def random_chars(length)
        random_bytes(length).map { |b| b.chr }
      end

      #
      # Returns a String of the specified _length_ containing
      # random characters from the character set.
      #
      def random_string(length)
        random_chars(length).join
      end

      #
      # Creates a new CharSet object containing the both the characters
      # of the character set and the specified _other_set_.
      #
      def |(other_set)
        super(CharSet.new(other_set))
      end

      alias + |

      #
      # Returns +true+ if all of the bytes within the specified _string_
      # are included in the character set, returns +false+ otherwise.
      #
      #   Chars.alpha =~ "hello"
      #   # => true
      #
      def =~(string)
        string.each_byte do |b|
          return false unless include?(b)
        end

        return true
      end

      #
      # Inspects the character set.
      #
      def inspect
        "#<#{self.class.name}: {" + map { |b|
          case b
          when (0x07..0x0d), (0x20..0x7e)
            b.chr.dump
          when 0x00
            # sly hack to make char-sets more friendly
            # to us C programmers
            '"\0"'
          else
            "0x%02x" % b
          end
        }.join(', ') + "}>"
      end

    end
  end
end

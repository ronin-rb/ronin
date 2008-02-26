#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
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

module Ronin
  module Text
    class CharSet < Array

      def initialize(*chars)
        chars = chars.flatten.map do |char|
          if char.kind_of?(Range)
            char.to_a
          elsif char.kind_of?(Integer)
            char.chr
          else
            char.to_s
          end
        end

        super(chars.flatten.uniq)
      end

      def select(&block)
        CharSet.new(super(&block))
      end

      def map(&block)
        CharSet.new(super(&block))
      end

      #
      # Returns a random character from the character set.
      #
      def rand_char
        self[rand(self.length)]
      end

      def each_rand_char(length,&block)
        length.to_i.times { block.call(rand_char) }
      end

      #
      # Returns an Array of the specified _length_ containing
      # random characters from the character set.
      #
      def rand_array(length)
        Array.new(length) { rand_char }
      end

      #
      # Returns a String of the specified _length_ containing
      # random characters from the character set.
      #
      def rand_string(length)
        rand_array(length).join
      end

      def |(set)
        CharSet.new(self,set)
      end

      def +(set)
        self | set.to_a
      end

      def -(set)
        CharSet.new(super(set.to_a))
      end

      def with(*set)
        self + set
      end

      def without(*set)
        self - set
      end

    end
  end
end

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

require 'chars'

class String

  #
  # Creates a new String by formatting each byte.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Array, Range] :included (0x00..0xff)
  #   The bytes to format.
  #
  # @option options [Array, Range] :excluded
  #   The bytes not to format.
  #
  # @yield [byte]
  #   The block which will return the formatted version of each byte
  #   within the String.
  #
  # @yieldparam [Integer] byte
  #   The byte to format.
  #
  # @return [String]
  #   The formatted version of the String.
  #
  def format_bytes(options={},&block)
    included = (options[:included] || (0x00..0xff))
    excluded = (options[:excluded] || [])

    formatted = ''

    self.each_byte do |b|
      c = b.chr

      if ((included.include?(b) || included.include?(c)) \
          && !(excluded.include?(b) || excluded.include?(c)))
        formatted << block.call(b)
      else
        formatted << b
      end
    end

    return formatted
  end

  #
  # Creates a new String by formatting each character.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Array, Range] :included (0x00..0xff)
  #   The bytes to format.
  #
  # @option options [Array, Range] :excluded
  #   The bytes not to format.
  #
  # @yield [char]
  #   The block which will return the formatted version of each character
  #   within the String.
  #
  # @yieldparam [String] char
  #   The character to format.
  #
  # @return [String]
  #   The formatted version of the String.
  #
  def format_chars(options={},&block)
    format_bytes(options) do |b|
      block.call(b.chr)
    end
  end

  #
  # Creates a new String by randomizing the case of each character in the
  # String.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Array, Range] :included (0x00..0xff)
  #   The bytes to format.
  #
  # @option options [Array, Range] :excluded
  #   The bytes not to format.
  #
  # @option options [Float] :probability (0.5)
  #   The probability that a character will have it's case changed.
  #
  # @example
  #   "get out your checkbook".random_case
  #   # => "gEt Out YOur CHEckbook"
  #
  def random_case(options={})
    prob = (options[:probability] || 0.5)

    format_chars(options) do |c|
      if rand <= prob
        c.swapcase 
      else
        c
      end
    end
  end

  #
  # Creates a new String by padding the String with repeating text,
  # out to a specified length.
  #
  # @param [String] padding
  #   The text to pad the new String with.
  #
  # @param [String] max_length
  #   The maximum length to pad the new String out to.
  #
  # @return [String]
  #   The padded version of the String.
  #
  # @example
  #   "hello".pad('A',50)
  #   # => "helloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  #
  def pad(padding,max_length=self.length)
    padding = padding.to_s

    if max_length >= self.length
      max_length -= self.length
    else
      max_length = 0
    end

    padded = self + (padding * (max_length / padding.length))

    unless (remaining = max_length % padding.length) == 0
      padded += padding[0...remaining]
    end

    return padded
  end

end

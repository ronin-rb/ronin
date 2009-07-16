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

require 'chars'

class String

  #
  # Creates a new String by passing each byte to the specified _block_
  # using the given _options_.
  #
  # _options_ may include the following keys:
  # <tt>:included</tt>:: The set of characters that will be formated,
  #                      defaults to <tt>(0x00..0xff)</tt>.
  # <tt>:excluded</tt>:: The characters not to format.
  #
  def format_bytes(options={},&block)
    included = (options[:included] || (0x00..0xff))
    excluded = (options[:excluded] || [])

    targeted = included - excluded
    formatted = ''

    self.each_byte do |b|
      if targeted.include_byte?(b)
        formatted << block.call(b)
      else
        formatted << b
      end
    end

    return formatted
  end

  #
  # Creates a new String by passing each character to the specified _block_
  # using the given _options_.
  #
  # _options_ may include the following keys:
  # <tt>:included</tt>:: The set of characters that will be formated,
  #                      defaults to <tt>(0x00..0xff)</tt>.
  # <tt>:excluded</tt>:: The characters not to format.
  #
  def format_chars(options={},&block)
    format_bytes(options) do |b|
      block.call(b.chr)
    end
  end

  #
  # Creates a new String by randomizing the case of each character using
  # the given _options_.
  #
  # _options_ may include the following keys:
  # <tt>:probability</tt>:: The probability that a character will have it's
  #                         case changed; defaults to 0.5.
  #
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
  # Pads the string using the specified _padding_ out to the given
  # _max_length_. _max_length_ will default to the strings own length,
  # if not given.
  #
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

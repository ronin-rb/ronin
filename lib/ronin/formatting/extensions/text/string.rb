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

require 'ronin/chars'

class String

  #
  # Creates a new String by passing each character to the specified _block_
  # using the given _options_.
  #
  # _options_ may include the following keys:
  # <tt>:included</tt>:: The set of characters that will be formated,
  #                      defaults to <tt>Ronin::Chars.all</tt>.
  # <tt>:excluded</tt>:: The characters not to format.
  #
  def format_chars(options={},&block)
    included = (options[:included] || Ronin::Chars.all)
    excluded = (options[:excluded] || [])

    targeted = included - excluded
    formatted = ''

    self.each_byte do |b|
      c = b.chr

      if targeted.include_byte?(b)
        formatted << block.call(c)
      else
        formatted << c
      end
    end

    return formatted
  end

  #
  # Creates a new String by passing each byte to the specified _block_
  # using the given _options_.
  #
  # _options_ may include the following keys:
  # <tt>:included</tt>:: The set of characters that will be formated,
  #                      defaults to <tt>Ronin::Chars.all</tt>.
  # <tt>:excluded</tt>:: The characters not to format.
  #
  def format_bytes(options={},&block)
    format_chars(options) do |c|
      i = block.call(c[0])

      if i.kind_of?(Integer)
        i.chr
      else
        i.to_s
      end
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
  # "get out your checkbook".rand_case
  # # => "gEt Out YOur CHEckbook"
  #
  def random_case(options={})
    prob = (options[:probability] || 0.5)

    format_chars(options) do |c|
      if rand < prob
        c.swapcase 
      else
        c
      end
    end
  end

end

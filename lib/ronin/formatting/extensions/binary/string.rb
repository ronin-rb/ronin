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

require 'ronin/formatting/extensions/text'
require 'ronin/arch'

require 'base64'

class String

  #
  # Packs the integer using the specified _arch_ and the given
  # _address_length_. The _address_length_ will default to the address
  # length of the _arch_.
  #
  #   0x41.pack(Arch('i686')) # => "A\000\000\000"
  #
  #   0x41.pack(Arch('ppc'),2) # => "\000A"
  #
  def depack(arch,address_length=arch.address_length)
    integer = 0x0

    if arch.endian=='little'
      address_length.times do |i|
        if self[i]
          integer = (integer | (self[i] << (i*8)))
        end
      end
    elsif arch.endian=='big'
      address_length.times do |i|
        if self[i]
          integer = (integer | (self[i] << ((address_length-i-1)*8)))
        end
      end
    end

    return integer
  end

  #
  # Returns the hex escaped form of the string.
  #
  #   "hello".hex_escape
  #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
  #
  def hex_escape(options={})
    format_bytes(options) { |b| "\\x%.2x" % b }
  end

  #
  # XOR encodes the string using the specified _key_.
  #
  def xor(key)
    encoded = ''

    each_byte { |b| encoded << (b ^ key).chr }
    return encoded
  end

  #
  # Returns the base64 encoded form of the string.
  #
  def base64_encode
    Base64.encode64(self)
  end

  #
  # Returns the base64 decoded form of the string.
  #
  def base64_decode
    Base64.decode64(self)
  end

  #
  # Converts a multitude of hexdump formats back into their original
  # binary form using the given _options_.
  #
  # _options_ may contain the following keys:
  # <tt>:segment</tt>:: The length in bytes of each segment in the hexdump.
  #                    Defaults to 16, if not specified.
  # <tt>:encoding</tt>: Denotes the encoding uses for the bytes within the
  #                     hexdump. Must be either <tt>:dec</tt>,
  #                     <tt>:hex</tt> or <tt>:octal</tt>, defaults to
  #                     <tt>:hex</tt> if unspecified.
  #
  def unhexdump(options={})
    encoding = (options[:encoding] || :hex)
    current_addr = last_addr = 0
    repeated = false

    segment_length = (options[:segment] || 16)
    segment = []
    bytes = []

    each_line do |line|
      words = line.split

      if words.first == '*'
        repeated = true
      elsif words.length > 0
        current_addr = words.first.hex

        if repeated
          ((current_addr - last_addr) / segment.length).times do
            bytes += segment
          end

          repeated = false
        end

        segment = []

        words[1..-1].each do |word|
          break unless word =~ /^[0-9-a-fA-F]+$/

          case encoding
          when :dec
            segment << word.to_i
          when :hex
            segment << word.hex
          when :octal
            segment << word.oct
          end
        end

        bytes += segment
        last_addr = current_addr
      end
    end

    return bytes
  end

end

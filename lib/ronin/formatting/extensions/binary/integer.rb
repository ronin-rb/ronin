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

require 'ronin/arch'

class Integer

  #
  # Extracts a sequence of bytes which represent the Integer.
  #
  # @param [Integer] address_length
  #   The number of bytes to decode from the Integer.
  #
  # @param [Symbol] endian
  #   The endianness to use while decoding the bytes of the Integer.
  #   May be either +:big+, +:little+ or +:net+.
  #
  # @return [Array]
  #   The bytes decoded from the Integer.
  #
  # @example
  #   0xff41.bytes(2)
  #   # => [65, 255]
  #
  # @example
  #   0xff41.bytes(4, :big)
  #   # => [0, 0, 255, 65]
  #
  def bytes(address_length,endian=:little)
    endian = endian.to_s
    buffer = []

    if (endian == 'little' || endian == 'net')
      mask = 0xff

      address_length.times do |i|
        buffer << ((self & mask) >> (i*8))
        mask <<= 8
      end
    elsif endian == 'big'
      mask = (0xff << ((address_length-1)*8))

      address_length.times do |i|
        buffer << ((self & mask) >> ((address_length-i-1)*8))
        mask >>= 8
      end
    end

    return buffer
  end

  #
  # Packs the Integer into a String, for a specific architecture and
  # address-length.
  #
  # @param [Ronin::Arch] arch
  #   The architecture to pack the Integer for.
  #
  # @param [Integer] address_length
  #   The number of bytes to pack.
  #
  # @return [String]
  #   The packed Integer.
  #
  # @example
  #   0x41.pack(Arch.i686) # => "A\000\000\000"
  #
  # @example
  #   0x41.pack(Arch.ppc,2) # => "\000A"
  #
  def pack(arch,address_length=arch.address_length)
    bytes(address_length,arch.endian).map { |b| b.chr }.join
  end

  #
  # @return [String]
  #   The hex escaped version of the Integer.
  #
  # @example
  #   42.hex_escape
  #   # => "\\x2a"
  #
  def hex_escape
    "\\x%.2x" % self
  end

end

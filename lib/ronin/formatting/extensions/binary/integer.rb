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

require 'ronin/arch'

class Integer

  #
  # Packs the integer using the specified _arch_ and the given
  # _address_length_. The _address_length_ will default to the address
  # length of the _arch_.
  #
  #   0x41.pack(Arch.i686) # => "A\000\000\000"
  #
  #   0x41.pack(Arch.ppc,2) # => "\000A"
  #
  def pack(arch,address_length=arch.address_length)
    buffer = ""

    if arch.endian=='little'
      mask = 0xff

      address_length.times do |i|
        buffer+=((self & mask) >> (i*8)).chr
        mask <<= 8
      end
    elsif arch.endian=='big'
      mask = (0xff << ((address_length-1)*8))

      address_length.times do |i|
        buffer+=((self & mask) >> ((address_length-i-1)*8)).chr
        mask >>= 8
      end
    end

    return buffer
  end

end

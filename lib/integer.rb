require 'arch'

class Integer

  def pack(arch,address_length=arch.address_length)
    buffer = ""

    if arch.endian==Ronin::LITTLE_ENDIAN
      mask = 0xff

      address_length.times do |i|
        buffer+=((self & mask) >> (i*8)).chr
        mask <<= 8
      end
    elsif arch.endian==Ronin::BIG_ENDIAN
      mask = (0xff << ((address_length-1)*8))

      address_length.times do |i|
        buffer+=((self & mask) >> ((address_length-i-1)*8)).chr
        mask >>= 8
      end
    end

    return buffer
  end

end

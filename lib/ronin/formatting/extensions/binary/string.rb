#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/formatting/extensions/binary/integer'
require 'ronin/formatting/extensions/text'
require 'ronin/arch'

require 'base64'
require 'enumerator'

begin
  require 'zlib'
rescue Gem::LoadError => e
  raise(e)
rescue ::LoadError
end

class String

  #
  # Packs an Integer from a String, which was originally packed for
  # a specific architecture and address-length.
  #
  # @param [Ronin::Arch] arch
  #   The architecture that the Integer was originally packed with.
  #
  # @param [Integer] address_length
  #   The number of bytes to depack.
  #
  # @return [Integer]
  #   The depacked Integer.
  #
  # @example
  #   0x41.pack(Arch('i686')) # => "A\000\000\000"
  #
  # @example
  #   0x41.pack(Arch('ppc'),2) # => "\000A"
  #
  def depack(arch,address_length=arch.address_length)
    integer = 0x0
    byte_index = 0

    if arch.endian == 'little'
      mask = lambda { |b| b << (byte_index * 8) }
    elsif arch.endian == 'big'
      mask = lambda { |b|
        b << ((address_length - byte_index - 1) * 8)
      }
    end

    self.each_byte do |b|
      break if byte_index >= address_length

      integer |= mask.call(b)
      byte_index += 1
    end

    return integer
  end

  #
  # @return [String]
  #   The hex escaped version of the String.
  #
  # @example
  #   "hello".hex_escape
  #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
  #
  def hex_escape(options={})
    format_bytes(options) { |b| "\\x%.2x" % b }
  end

  #
  # @return [String]
  #   The unescaped version of the hex escaped String.
  #
  # @example
  #   "\\x68\\x65\\x6c\\x6c\\x6f".hex_unescape
  #   # => "hello"
  #
  def hex_unescape
    buffer = ''
    hex_index = 0
    hex_length = length

    while (hex_index < hex_length)
      hex_substring = self[hex_index..-1]

      if hex_substring =~ /^\\[0-7]{3}/
        buffer << hex_substring[0..3].to_i(8)
        hex_index += 3
      elsif hex_substring =~ /^\\x[0-9a-fA-F]{1,2}/
        hex_substring[2..-1].scan(/^[0-9a-fA-F]{1,2}/) do |hex_byte|
          buffer << hex_byte.to_i(16)
          hex_index += (2 + hex_byte.length)
        end
      elsif hex_substring =~ /^\\./
        escaped_char = hex_substring[1..1]

        buffer << case escaped_char
                  when '0'
                    "\0"
                  when 'a'
                    "\a"
                  when 'b'
                    "\b"
                  when 't'
                    "\t"
                  when 'n'
                    "\n"
                  when 'v'
                    "\v"
                  when 'f'
                    "\f"
                  when 'r'
                    "\r"
                  else
                    escaped_char
                  end
        hex_index += 2
      else
        buffer << hex_substring[0]
        hex_index += 1
      end
    end

    return buffer
  end

  #
  # XOR encodes the String.
  #
  # @param [Enumerable, Integer] key
  #   The byte to XOR against each byte in the String.
  #
  # @return [String]
  #   The XOR encoded String.
  #
  # @example
  #   "hello".xor(0x41)
  #   # => ")$--."
  #
  # @example
  #   "hello again".xor([0x55, 0x41, 0xe1])
  #   # => "=$\x8d9.\xc14&\x80</"
  #
  def xor(key)
    encoded = ''

    # expand key into many keys
    keys = if key.kind_of?(Enumerable)
             key.to_a
           else
             [key]
           end

    # make sure all keys are integers
    keys.map! { |key| key.to_i }

    Enumerator.new(self,:each_byte).each_with_index do |b,i|
      encoded << (b ^ keys[i % keys.length]).chr
    end

    return encoded
  end

  #
  # Base64 encodes a string.
  #
  # @return [String]
  #   The base64 encoded form of the string.
  #
  def base64_encode
    Base64.encode64(self)
  end

  #
  # Base64 decodes a string.
  #
  # @return [String]
  #   The base64 decoded form of the string.
  #
  def base64_decode
    Base64.decode64(self)
  end

  #
  # Zlib inflate a string.
  #
  # @return [String]
  #   The zlib inflated form of the string.
  #
  def zlib_inflate
    Zlib::Inflate.inflate(self)
  end

  #
  # Zlib deflate a string.
  #
  # @return [String]
  #   The zlib deflated form of the string.
  #
  def zlib_deflate
    Zlib::Deflate.deflate(self)
  end

  #
  # Converts a multitude of hexdump formats back into raw-data.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Symbol] :format
  #   The expected format of the hexdump. Must be either +:od+ or
  #   +:hexdump+.
  #
  # @option options [Symbol] :encoding
  #   Denotes the encoding used for the bytes within the hexdump.
  #   Must be one of the following: +:binary+, +:octal+, +:octal_bytes+
  #   +:octal_shorts+, +:octal_ints+, :octal_quads+, +:decimal+,
  #   +:decimal_bytes+, +:decimal_shorts+, +:decimal_ints+,
  #   +:decimal_quads+, +:hex+ +:hex_bytes+, +:hex_shorts+, +:hex_ints+ or
  #   +:hex_quads+.
  #
  # @option options [Integer] :segment (16)
  #   The length in bytes of each segment in the hexdump.
  #
  # @return [String] The raw-data from the hexdump.
  #
  def unhexdump(options={})
    case (format = options[:format])
    when :od
      address_base = base = 8
      word_size = 2
    when :hexdump
      address_base = base = 16
      word_size = 2
    else
      address_base = base = 16
      word_size = 1
    end

    case options[:encoding]
    when :binary
      base = 2
    when :octal, :octal_bytes, :octal_shorts, :octal_ints, :octal_quads
      base = 8
    when :decimal, :decimal_bytes, :decimal_shorts, :decimal_ints, :decimal_quads
      base = 10
    when :hex, :hex_bytes, :hex_shorts, :hex_ints, :hex_quads
      base = 16
    end

    case options[:encoding]
    when :binary, :octal_bytes, :decimal_bytes, :hex_bytes
      word_size = 1
    when :octal_shorts, :decimal_shorts, :hex_shorts
      word_size = 2
    when :octal_ints, :decimal_ints, :hex_ints
      word_size = 4
    when :octal_quads, :decimal_quads, :hex_quads
      word_size = 8
    end

    current_addr = last_addr = first_addr = nil
    repeated = false

    segment_length = (options[:segment] || 16)
    segment = []
    buffer = []

    each_line do |line|
      if format == :hexdump
        line = line.gsub(/\s+\|.+\|\s*$/,'')
      end

      words = line.split

      if words.first == '*'
        repeated = true
      elsif words.length > 0
        current_addr = words.shift.to_i(address_base)
        first_addr ||= current_addr

        if repeated
          (((current_addr - last_addr) / segment.length) - 1).times do
            buffer += segment
          end

          repeated = false
        end

        segment.clear

        words.each do |word|
          if (base != 10 && word =~ /^(\\[0abtnvfr\\]|.)$/)
            word.hex_unescape.each_byte { |b| segment << b }
          else
            segment += word.to_i(base).bytes(word_size)
          end
        end

        segment = segment[0...segment_length]
        buffer += segment
        last_addr = current_addr
      end
    end

    return buffer[0...(last_addr - first_addr)]
  end

end

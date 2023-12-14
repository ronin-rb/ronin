# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/cli/command'
require 'ronin/cli/binary_template'

module Ronin
  class CLI
    module Commands
      #
      # Unpacks binary data.
      #
      # ## Usage
      #
      #     ronin unpack [options] TYPE [...]
      #
      # ## Options
      #
      #     -E, --endian little|big|net      Sets the endianness
      #     -A x86|x86_64|ppc|ppc64|mips|mips_le|mips_be|mips64|mips64_le|mips64_be|arm|arm_le|arm_be|arm64|arm64_le|arm64_be,
      #         --arch                       Sets the architecture
      #     -O linux|macos|windows|android|apple_ios|bsd|freebsd|openbsd|netbsd,
      #         --os                         Sets the OS
      #     -S, --string $'\xXX\x..'         The raw binary string to unpack
      #     -f, --file FILE                  The binary file to unpack
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     TYPE:VALUE                      A value and it's type.
      #
      # ### Types
      #
      #     Native             Little-endian       Big-endian          Network-endian
      #     ------             -------------       ----------          --------------
      #
      #     char
      #     uchar
      #     byte
      #     string
      #     int                int_le              int_be              int_net
      #     int8
      #     int16              int16_le            int16_be            int16_net
      #     int32              int32_le            int32_be            int32_net
      #     int64              int64_le            int64_be            int64_net
      #     short              short_le            short_be            short_net
      #     long               long_le             long_be             long_net
      #     long_long          long_long_le        long_long_be        long_long_net
      #     uint               uint_le             uint_be             uint_net
      #     uint8
      #     uint1616           uint16_le           uint16_be           uint16_net
      #     uint3232           uint32_le           uint32_be           uint32_net
      #     uint6464           uint64_le           uint64_be           uint64_net
      #     ushort             ushort_le           ushort_be           ushort_net
      #     ulong              ulong_le            ulong_be            ulong_net
      #     ulong_long         ulong_long_le       ulong_long_be       ulong_long_net
      #     float              float_le            float_be            float_net
      #     float32            float32_le          float32_be          float32_net
      #     float64            float64_le          float64_be          float64_net
      #     double             double_le           double_be           double_net
      #     pointer            pointer_le          pointer_be          pointer_net
      #
      # ## Examples
      #
      #     ronin unpack int32 uint32 char string
      #     ronin unpack int32[4] string[3]
      #     ronin unpack uint32_le
      #     ronin unpack uint32_be
      #     ronin unpack --endian big int uint
      #     ronin unpack --arch arm_le int long
      #     ronin unpack --arch x86_64 --os windows uint
      #     ronin unpack --string $'\x44\x33\x22\x11' int32
      #     ronin unpack --file int32.dat int32
      #     ronin pack int32:0x11223344 | ronin unpack int32
      #
      # @since 2.1.0
      #
      class Unpack < Command

        include BinaryTemplate

        option :string, short: '-S',
                        value: {
                          type:  String,
                          usage: "$'\\xXX\\x..'"
                        },
                        desc: 'The raw binary string to unpack'

        option :file, short: '-f',
                      value: {
                        type:  String,
                        usage: 'FILE'
                      },
                      desc: 'The binary file to unpack'

        argument :type, required: true,
                        repeats:  true,
                        desc:     'A C type to unpack'

        examples [
          'int32 uint32 char string',
          'int32[4] string[3]',
          'uint32_le',
          'uint32_be',
          '--endian big int uint',
          '--arch arm_le int long',
          '--arch x86_64 --os windows uint',
          '--string $\'\x44\x33\x22\x11\' int32',
          '--file int32.dat int32',
          'int32'
        ]

        description 'Unpacks binary data'

        man_page 'ronin-unpack.1'

        #
        # Runs the `ronin unpack` command.
        #
        # @param [Array<String>] args
        #   The `TYPE` arguments to parse.
        #
        def run(*args)
          types    = args.map(&method(:parse_type))
          template = build_template(types)

          data = if options[:string]
                   options[:string]
                 elsif options[:file]
                   File.binread(options[:file])
                 else
                   stdin.read
                 end

          values = template.unpack(data)

          # remove the outer-most square brackets
          print_array_value(values)
          puts
        end

        #
        # Prints an Array of values.
        #
        # @param [Array<Integer, Float, String, Ronin::Support::Binary::Array>] value
        #   The array value to print.
        #
        def print_array_value(value)
          # convert Ronin::Support::Binary::Array objects to plain Arrays
          value = value.to_a

          print '['

          value.each_with_index do |element,index|
            print_value(element)
            print(', ') unless (index == (value.length - 1))
          end

          print ']'
        end

        #
        # Prints an individual value.
        #
        # @param [Integer, Float, String, Ronin::Support::Binary::Array] value
        #   The value to print.
        #
        def print_value(value)
          case value
          when Array, Support::Binary::Array
            print_array_value(value)
          else
            print(value.inspect)
          end
        end

      end
    end
  end
end

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

require_relative '../command'
require_relative '../binary_template'

module Ronin
  class CLI
    module Commands
      #
      # Packs values into binary data.
      #
      # ## Usage
      #
      #     ronin pack [options] TYPE:VALUE [...]
      #
      # ## Options
      #
      #     -E, --endian little|big|net      Sets the endianness
      #     -A x86|x86_64|ppc|ppc64|mips|mips_le|mips_be|mips64|mips64_le|mips64_be|arm|arm_le|arm_be|arm64|arm64_le|arm64_be,
      #         --arch                       Sets the architecture
      #     -O linux|macos|windows|android|apple_ios|bsd|freebsd|openbsd|netbsd,
      #         --os                         Sets the OS
      #     -x, --hexdump                    Hexdumps the packed data, instead of writing it out
      #         --output PATH                Optional output file to write to
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
      #     ronin pack int32:-1 uint32:0x12345678 char:A string:hello
      #     ronin pack int32[4]:1,2,3,4 string[3]:hello,world
      #     ronin pack uint32_le:0x12345678
      #     ronin pack uint32_be:0x12345678
      #     ronin pack --endian big int:4096 uint:0x12345678
      #     ronin pack --arch arm_le int:4096 long:0x12345678
      #     ronin pack --arch x86_64 --os windows uint:0x12345678
      #
      # @since 2.1.0
      #
      class Pack < Command

        include BinaryTemplate

        option :hexdump, short: '-x',
                         desc:  'Hexdumps the packed data, instead of writing it out' do
                           require 'hexdump'
                         end

        option :output, value: {
                          type: String,
                          usage: 'PATH'
                        },
                        desc: 'Optional output file to write to'

        argument :element, required: true,
                           repeats:  true,
                           usage:    'TYPE:VALUE',
                           desc:     "A value and it's C type"

        examples [
          'int32:-1 uint32:0x12345678 char:A string:hello',
          'int32[4]:1,2,3,4 string[3]:hello,world',
          'uint32_le:0x12345678',
          'uint32_be:0x12345678',
          '--endian big int:4096 uint:0x12345678',
          '--arch arm_le int:4096 long:0x12345678',
          '--arch x86_64 --os windows uint:0x12345678'
        ]

        description "Packs values into binary data"

        man_page 'ronin-pack.1'

        #
        # Runs the `ronin pack` command.
        #
        # @param [Array<String>] args
        #   The `TYPE:VALUE` strings to parse and pack.
        #
        def run(*args)
          # perform an initial parsing of the arguments to extract types/values
          types, values = parse_types_and_values(args)

          # build the template using the parsed `TYPE`s
          template = build_template(types)

          # parse the values, but using the resolved C types.
          values = parse_values(template.types,values)

          # finally pack the parsed values using the binary template
          data = template.pack(*values)

          if options[:hexdump]
            data.hexdump
          else
            write_output(data)
          end
        end

        #
        # Prints the help information for the arguments and lists `TYPE`s.
        #
        def help_arguments
          super

          puts
          puts <<HELP
Types:

    Native             Little-endian       Big-endian          Network-endian
    ------             -------------       ----------          --------------

    char
    uchar
    byte
    string
    int                int_le              int_be              int_net
    int8
    int16              int16_le            int16_be            int16_net
    int32              int32_le            int32_be            int32_net
    int64              int64_le            int64_be            int64_net
    short              short_le            short_be            short_net
    long               long_le             long_be             long_net
    long_long          long_long_le        long_long_be        long_long_net
    uint               uint_le             uint_be             uint_net
    uint8
    uint1616           uint16_le           uint16_be           uint16_net
    uint3232           uint32_le           uint32_be           uint32_net
    uint6464           uint64_le           uint64_be           uint64_net
    ushort             ushort_le           ushort_be           ushort_net
    ulong              ulong_le            ulong_be            ulong_net
    ulong_long         ulong_long_le       ulong_long_be       ulong_long_net
    float              float_le            float_be            float_net
    float32            float32_le          float32_be          float32_net
    float64            float64_le          float64_be          float64_net
    double             double_le           double_be           double_net
    pointer            pointer_le          pointer_be          pointer_net
HELP
        end

        #
        # Performs an initial parsing of the `TYPE:VALUE` arguments into two
        # separate lists of `TYPE`s and `VALUE`s.
        #
        # @param [Array<String>] args
        #   The `TYPE:VALUE` argumens to parse.
        #
        # @return [(Array<Symbol, (Symbol, Integer)>, Array<String>)]
        #   The parsed types and values.
        #
        def parse_types_and_values(args)
          types  = []
          values = []

          args.each do |string|
            type, value = string.split(':',2)

            types  << parse_type(type)
            values << value
          end

          return types, values
        end

        #
        # Performs a second parsing of the values based on their desired
        # C types.
        #
        # @param [Array<Ronin::Support::Binary::CTypes::Type>] types
        #   The desired types of the values.
        #
        # @param [Array<String, Array<String>>] values
        #   The values to further parse.
        #
        def parse_values(types,values)
          # now parse the values based on their resolved CType types
          values.map.with_index do |value,index|
            parse_value(types[index],value)
          end
        end

        #
        # Parses the value based on it's C type.
        #
        # @param [Ronin::Support::Binary::CType::Type] ctype
        #   The C type of the value.
        #
        # @param [String] string
        #   The raw unparsed string.
        #
        # @return [Array<Integer>, Array<Float>, Array<String>, Integer, Float, String]
        #   The parsed value.
        #
        def parse_value(ctype,string)
          case ctype
          when Support::Binary::CTypes::ArrayType,
               Support::Binary::CTypes::ArrayObjectType,
               Support::Binary::CTypes::UnboundedArrayType
            parse_array_value(ctype,string)
          when Support::Binary::CTypes::IntType,
               Support::Binary::CTypes::UIntType
            parse_int(string)
          when Support::Binary::CTypes::FloatType
            parse_float(string)
          when Support::Binary::CTypes::CharType,
               Support::Binary::CTypes::StringType
            string
          else
            raise(NotImplementedError,"unable to parse value for CType #{ctype.class}")
          end
        end

        #
        # Parses an array.
        #
        # @param [Ronin::Support::Binary::CTypes::Type] ctype
        #   The C type that represents the array type.
        #
        # @param [String] string
        #   The raw string to parse.
        #
        # @return [Array<Integer>, Array<Float>, Array<String>]
        #   The parsed array.
        #
        def parse_array_value(ctype,string)
          # create array of the desired size
          array = if ctype.length.finite?
                    Array.new(ctype.length,ctype.type.uninitialized_value)
                  else
                    []
                  end

          string.split(/(?!\\),/).each_with_index do |element,index|
            array[index] = parse_value(ctype.type,element)
          end

          return array
        end

        #
        # Parses an integer value.
        #
        # @param [String] string
        #   The raw string to parse.
        #
        # @return [Integer]
        #   The parsed Integer.
        #
        def parse_int(string)
          Integer(string)
        rescue ArgumentError
          print_error "cannot parse integer: #{string}"
          exit(-1)
        end

        #
        # Parses an float value.
        #
        # @param [String] string
        #   The raw string to parse.
        #
        # @return [Float]
        #   The parsed Float.
        #
        def parse_float(string)
          Float(string)
        rescue ArgumentError
          print_error "cannot parse float: #{string}"
          exit(-1)
        end

        #
        # Writes the packed data to the `--output` file or stdout.
        #
        # @param [String] data
        #   The packed data to output.
        #
        def write_output(data)
          if options[:output]
            File.binwrite(options[:output],data)
          else
            stdout.write(data)
          end
        end

      end
    end
  end
end

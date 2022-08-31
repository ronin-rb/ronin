#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/support/binary/hexdump/parser'

module Ronin
  class CLI
    module Commands
      #
      # Hexdumps data in a variety of encodings and formats.
      #
      # ## Usage
      #
      #     ronin unhexdump [options] [FILE]
      #
      # ## Options
      #
      #    -o, --output FILE                Optional output file
      #    -f, --format od|hexdump          Format of the hexdump input (Default: hexdump)
      #    -t int8|uint8|char|uchar|byte|int16|int16_le|int16_be|int16_ne|uint16|uint16_le|uint16_be|uint16_ne|short|short_le|short_be|short_ne|ushort|ushort_le|ushort_be|ushort_ne|int32|int32_le|int32_be|int32_ne|uint32|uint32_le|uint32_be|uint32_ne|int|long|long_le|long_be|long_ne|uint|ulong|ulong_le|ulong_be|ulong_ne|int64|int64_le|int64_be|int64_ne|uint64|uint64_le|uint64_be|uint64_ne|long_long|long_long_le|long_long_be|long_long_ne|ulong_long|ulong_long_le|ulong_long_be|ulong_long_ne|float|float_le|float_be|float_ne|double|double_le|double_be|double_ne,
      #        --type                       The binary data type to decode the data as
      #    -b, --base 2|8|10|16             Numerical base of the hexdumped numbers
      #    -A, --address-base 2|8|10|16     Numerical base of the address column
      #        --[no-]named-chars           Enables parsing of od-style named charactters
      #    -h, --help                       Print help information
      #
      # ## Arguments
      #
      #    [FILE]                           Optional file to unhexdump
      #
      class Unhexdump < Command

        # Supported types for the `-t,--type` option.
        TYPES = [
          :int8,
          :uint8,
          :char,
          :uchar,
          :byte, # default for --format hexdump
          :int16,
          :int16_le,
          :int16_be,
          :int16_ne,
          :uint16,
          :uint16_le, # default for --format od
          :uint16_be,
          :uint16_ne,
          :short,
          :short_le,
          :short_be,
          :short_ne,
          :ushort,
          :ushort_le,
          :ushort_be,
          :ushort_ne,
          :int32,
          :int32_le,
          :int32_be,
          :int32_ne,
          :uint32,
          :uint32_le,
          :uint32_be,
          :uint32_ne,
          :int,
          :long,
          :long_le,
          :long_be,
          :long_ne,
          :uint,
          :ulong,
          :ulong_le,
          :ulong_be,
          :ulong_ne,
          :int64,
          :int64_le,
          :int64_be,
          :int64_ne,
          :uint64,
          :uint64_le,
          :uint64_be,
          :uint64_ne,
          :long_long,
          :long_long_le,
          :long_long_be,
          :long_long_ne,
          :ulong_long,
          :ulong_long_le,
          :ulong_long_be,
          :ulong_long_ne,
          :float,
          :float_le,
          :float_be,
          :float_ne,
          :double,
          :double_le,
          :double_be,
          :double_ne
        ]

        usage '[options] [FILE]'

        option :output, short: '-o',
                        value: {
                          type:  String,
                          usage: 'FILE'
                        },
                        desc: 'Optional output file'

        option :format, short: '-f',
                        value: {
                          type: [:od, :hexdump],
                          default: :hexdump
                        },
                        desc: 'Format of the hexdump input'

        option :type, short: '-t',
                      value: {type: TYPES},
                      desc:  'The binary data type to decode the data as'

        BASES = {'2' => 2, '8' => 8, '10' => 10, '16' => 16}

        option :base, short: '-b',
                      value: {type: BASES},
                      desc: 'Numerical base of the hexdumped numbers'

        option :address_base, short: '-A',
                              value: {type:  BASES},
                              desc: 'Numerical base of the address column'

        option :named_chars, long: '--[no-]named-chars',
                             desc: 'Enables parsing of od-style named charactters'

        argument :file, required: false,
                        desc: 'Optional file to unhexdump'

        #
        # Runs the `unhexdump` command.
        #
        # @param [String, nil] file
        #   Optional input file.
        #
        def run(file=nil)
          parser = Support::Binary::Hexdump::Parser.new(
                     **hexdump_parser_options
                   )

          input = if file
                    begin
                      File.open(file)
                    rescue Errno::ENOENT
                      print_error "no such file or directory: #{file}"
                      exit(1)
                    end
                  else
                    stdin
                  end

          data = parser.unhexdump(input)

          if options[:output]
            File.binwrite(options[:output],data)
          else
            stdout.write(data)
          end
        end

        HEXDUMP_PARSER_OPTIONS = [
          :format,
          :type,
          :address_base,
          :base,
          :named_chars
        ]

        #
        # Builds a keyword arguments `Hash` of all command `options` that will
        # be directly passed to
        # `Ronin::Support::Binary::Hexdump::Parser#initialize`.
        #
        # @return [Hash{Symbol => Object}]
        #
        def hexdump_parser_options
          kwargs = {}

          HEXDUMP_PARSER_OPTIONS.each do |key|
            kwargs[key] = options[key] if options.has_key?(key)
          end

          return kwargs
        end

      end
    end
  end
end

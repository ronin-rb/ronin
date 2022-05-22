#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin.
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

require 'hexdump'

module Ronin
  class CLI
    module Commands
      #
      # Hexdumps data in a variety of encodings and formats.
      #
      # ## Usage
      #
      #     ronin hexdump [options] [FILE]
      #
      # ## Options
      #
      #    -o, --output FILE                Optional output file
      #    -t int8|uint8|char|uchar|byte|int16|int16_le|int16_be|int16_ne|uint16|uint16_le|uint16_be|uint16_ne|short|short_le|short_be|short_ne|ushort|ushort_le|ushort_be|ushort_ne|int32|int32_le|int32_be|int32_ne|uint32|uint32_le|uint32_be|uint32_ne|int|long|long_le|long_be|long_ne|uint|ulong|ulong_le|ulong_be|ulong_ne|int64|int64_le|int64_be|int64_ne|uint64|uint64_le|uint64_be|uint64_ne|long_long|long_long_le|long_long_be|long_long_ne|ulong_long|ulong_long_le|ulong_long_be|ulong_long_ne|float|float_le|float_be|float_ne|double|double_le|double_be|double_ne,
      #        --type                       The binary data type to decode the data as (Default: byte)
      #    -O, --offset INDEX               Offset within the data to start hexdumping at
      #    -L, --length LEN                 Length of data to hexdump
      #    -Z, --zero-pad                   Enables zero-padding the input data
      #    -c, --columns WIDTH              The number of bytes to hexdump per line
      #    -g, --group-columns WIDTH        Groups columns together
      #    -G, --group-chars WIDTH|type     Group characters into columns
      #    -r, --[no-]repeating             Allows repeating lines in hexdump output
      #    -b, --base 2|8|10|16             Base to print numbers in
      #    -B, --index-base 2|8|10|16       Base to print the index addresses in
      #    -I, --index-offset INT           Starting number for the index addresses
      #    -C, --[no-]chars-column          Enables/disables the characters column
      #    -E, --encoding ascii|utf8        Encoding to display the characters in (Default: ascii)
      #    -h, --help                       Print help information
      #
      # ## Arguments
      #
      #    [FILE]                           Optional file to hexdump
      # 
      class Hexdump < Command

        # Supported types for the `-t,--type` option.
        TYPES = [
          :int8,
          :uint8,
          :char,
          :uchar,
          :byte, # default
          :int16,
          :int16_le,
          :int16_be,
          :int16_ne,
          :uint16,
          :uint16_le,
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

        option :type, short: '-t',
                      value: {
                        type:    TYPES,
                        default: :byte
                      },
                      desc:  'The binary data type to decode the data as'

        option :offset, short: '-O',
                        value: {
                          type:  Integer,
                          usage: 'INDEX'
                        },
                        desc: 'Offset within the data to start hexdumping at'

        option :length, short: '-L',
                        value: {
                          type: Integer,
                          usage: 'LEN',
                        },
                        desc: 'Length of data to hexdump'

        option :zero_pad, short: '-Z',
                          desc: 'Enables zero-padding the input data'

        option :columns, short: '-c',
                         value: {
                           type:  Integer,
                           usage: 'WIDTH'
                         },
                         desc:  'The number of bytes to hexdump per line'

        option :group_columns, short: '-g',
                               value: {
                                 type:  Integer,
                                 usage: 'WIDTH'
                               },
                               desc: 'Groups columns together'

        option :group_chars, short: '-G',
                             value: {usage: 'WIDTH|type'},
                             desc: 'Group characters into columns' do |value|
                               options[:group_chars] = parse_group_chars(value)
                             end

        option :repeating, short: '-r',
                           long: '--[no-]repeating',
                           desc: 'Allows repeating lines in hexdump output'

        # Mapping of supported values for the `-b,--base` option.
        BASES = {'2' => 2, '8' => 8, '10' => 10, '16' => 16}

        option :base, short: '-b',
                      value: {type: BASES},
                      desc: 'Base to print numbers in'

        option :index_base, short: '-B',
                            value: {type: BASES},
                            desc: 'Base to print the index addresses in'

        option :index_offset, short: '-I',
                              value: {type: Integer},
                              desc: 'Starting number for the index addresses'

        option :chars_column, short: '-C',
                              long: '--[no-]chars-column',
                              desc: 'Enables/disables the characters column'

        option :encoding, short: '-E',
                          value: {
                            type:    [:ascii, :utf8],
                            default: :ascii
                          },
                          desc: 'Encoding to display the characters in'

        argument :file, required: false,
                        desc: 'Optional file to hexdump'

        description 'Hexdumps data in a variaty of encodings and formats'

        #
        # Runs the `hexdump` command.
        #
        # @param [String, nil] file
        #   Optional input file.
        #
        def run(file=nil)
          input = if file then File.open(file,'rb')
                  else         stdin
                  end

          output = if options[:output]
                     File.open(options[:output],'w')
                   else
                     stdout
                   end

          Hexdump.hexdump(input, **hexdump_options, output: output)

          output.close if options[:output]
        end

        #
        # Parses the value passed to the `-G,--group-chars` option.
        #
        # @param [String] value
        #   The `-G,--group-chars` argument value.
        #
        # @return [Integer, :type]
        #   The parsed integer or `:type` if the `type` argument was given.
        #
        def parse_group_chars(value)
          case value
          when 'type'  then :type
          when /^\d+$/ then value.to_i
          else
            raise(OptionParser::InvalidArgument,"invalid value: #{value}")
          end
        end

        # List of command `options` that directly map to the keyword arguments
        # of `Hexdump.hexdump`.
        HEXDUMP_OPTIONS = [
          :format,
          :offset,
          :length,
          :zero_pad,
          :columns,
          :group_columns,
          :group_chars,
          :repeating,
          :base,
          :index_base,
          :index_offset,
          :chars_column,
          :encoding
        ]

        #
        # Creates a keyword arguments `Hash` of all command `options` that will
        # be directly passed to `Hexdump.hexdump`.
        #
        # @return [Hash{Symbol => Object}]
        #
        def hexdump_options
          kwargs = {}

          HEXDUMP_OPTIONS.each do |key|
            kwargs[key] = options[key] if options.has_key?(key)
          end

          return kwargs
        end

      end
    end
  end
end

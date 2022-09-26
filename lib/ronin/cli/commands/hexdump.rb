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

require 'ronin/cli/file_processor_command'

require 'hexdump'

module Ronin
  class CLI
    module Commands
      #
      # Hexdumps data in a variety of encodings and formats.
      #
      # ## Usage
      #
      #     ronin hexdump [options] [FILE ...]
      #
      # ## Options
      #
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
      #        --style-index STYLE          ANSI styles the index column
      #        --style-numeric STYLE        ANSI styles the numeric columns
      #        --style-chars STYLE          ANSI styles the characters column
      #        --highlight-index PATTERN:STYLE
      #                                     Applies ANSI highlighting to the index column
      #        --highlight-numeric PATTERN:STYLE
      #                                     Applies ANSI highlighting to the numeric column
      #        --highlight-chars PATTERN:STYLE
      #                                     Applies ANSI highlighting to the characters column
      #    -h, --help                       Print help information
      #
      # ## Arguments
      #
      #    [FILE]                           Optional file to hexdump
      # 
      class Hexdump < FileProcessorCommand

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

        option :style_index, value: {usage: 'STYLE'},
                             desc: 'ANSI styles the index column' do |value|
                               options[:style_index] = parse_style(value)
                             end

        option :style_numeric, value: {usage: 'STYLE'},
                               desc: 'ANSI styles the numeric columns' do |value|
                                 options[:style_numeric] = parse_style(value)
                               end

        option :style_chars, value: {usage: 'STYLE'},
                             desc: 'ANSI styles the characts column' do |value|
                               options[:style_chars] = parse_style(value)
                             end

        option :highlight_index, value: {usage: 'PATTERN:STYLE'},
                                   desc: 'Applies ANSI highlighting to the index column' do |value|
                                     pattern, style = parse_highlight(value)

                                     @highlight_index[pattern] = style
                                   end

        option :highlight_numeric, value: {usage: 'PATTERN:STYLE'},
                                   desc: 'Applies ANSI highlighting to the numeric column' do |value|
                                     pattern, style = parse_highlight(value)

                                     @highlight_numeric[pattern] = style
                                   end

        option :highlight_chars, value: {usage: 'PATTERN:STYLE'},
                                 desc: 'Applies ANSI highlighting to the characters column' do |value|
                                   pattern, style = parse_highlight(value)

                                   @highlight_chars[pattern] = style
                                 end

        description 'Hexdumps data in a variaty of encodings and formats'

        # The highlighting rules to apply to the index column.
        #
        # @return [Array<(Regexp, Array<Symbol>)>,
        #          Array<(String, Array<Symbol>)>]
        attr_reader :highlight_index

        # The highlighting rules to apply to the numeric column.
        #
        # @return [Array<(Regexp, Array<Symbol>)>,
        #          Array<(String, Array<Symbol>)>]
        attr_reader :highlight_numeric

        # The highlighting rules to apply to the characters column.
        #
        # @return [Array<(Regexp, Array<Symbol>)>,
        #          Array<(String, Array<Symbol>)>]
        attr_reader :highlight_chars

        #
        # Initializes the `hexdump` command.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @highlight_index   = {}
          @highlight_numeric = {}
          @highlight_chars   = {}
        end

        def run(*files)
          @hexdump = ::Hexdump::Hexdump.new(**hexdump_options)

          super(*files)
        end

        #
        # Opens the file in binary mode.
        #
        # @yield [file]
        #   If a block is given, the newly opened file will be yielded.
        #   Once the block returns the file will automatically be closed.
        #
        # @yieldparam [File] file
        #   The newly opened file.
        #
        # @return [File, nil]
        #   If no block is given, the newly opened file object will be returned.
        #   If no block was given, then `nil` will be returned.
        #
        def open_file(file,&block)
          File.open(file,'rb',&block)
        end

        #
        # Hexdumps the input stream.
        #
        # @param [IO, StringIO] input
        #   The input stream to hexdump.
        #
        def process_input(input)
          @hexdump.hexdump(input)
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

        # Mapping of style names to Symbols.
        STYLES = {
          # font styling
          'bold'      => :bold,
          'faint'     => :faint,
          'italic'    => :italic,
          'underline' => :underline,
          'invert'    => :invert,
          'strike'    => :strike,

          # foreground colors
          'black'   => :black,
          'red'     => :red,
          'green'   => :green,
          'yellow'  => :yellow,
          'blue'    => :blue,
          'magenta' => :magenta,
          'cyan'    => :cyan,
          'white'   => :white,

          # background colors
          'on_black'   => :on_black,
          'on_red'     => :on_red,
          'on_green'   => :on_green,
          'on_yellow'  => :on_yellow,
          'on_blue'    => :on_blue,
          'on_magenta' => :on_magenta,
          'on_cyan'    => :on_cyan,
          'on_white'   => :on_white
        }

        #
        # Parses a style string.
        #
        # @param [String] value
        #   The comma-separated list of style names.
        #
        # @return [Array<Symbol>]
        #   The array of parsed style names.
        #
        def parse_style(value)
          value.split(/\s*,\s*/).map do |style_name|
            STYLES.fetch(style_name) do
              raise(OptionParser::InvalidArgument,"unknown style name: #{style_name}")
            end
          end
        end

        #
        # Parses a highlight rule of the form `/REGEXP/:STYLE` or
        # `STRING:STYLE`.
        #
        # @param [String] value
        #   The raw string value to parse.
        #
        # @return [(Regexp, Array<Symbol>), (String, Array<Symbol>)]
        #   The Regexp or String pattern to match and the style rules to apply
        #   to it.
        #
        def parse_highlight(value)
          if value.start_with?('/')
            unless (index = value.rindex('/:'))
              raise(OptionParser::InvalidArgument,"argument must be of the form /REGEXP/:STYLE but was: #{value}")
            end

            regexp = Regexp.new(value[1...index])
            style  = parse_style(value[index+2..])

            return [regexp, style]
          else
            unless (index = value.rindex(':'))
              raise(OptionParser::InvalidArgument,"argument must be of the form STRING:STYLE but was: #{value}")
            end

            pattern = value[0...index]
            style   = parse_style(value[index+1..])

            return [pattern, style]
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

          if (index_style   = options[:style_index]) ||
             (numeric_style = options[:style_numeric]) ||
             (chars_style   = options[:style_chars])
            kwargs[:style] = {}
            kwargs[:style][:index]   = index_style   if index_style
            kwargs[:style][:numeric] = numeric_style if numeric_style
            kwargs[:style][:chars]   = chars_style   if chars_style
          end

          if !@highlight_index.empty?   ||
             !@highlight_numeric.empty? ||
             !@highlight_chars.empty?
            kwargs[:highlights] = {}

            unless @highlight_index.empty?
              kwargs[:highlights][:index] = @highlight_index
            end

            unless @highlight_numeric.empty?
              kwargs[:highlights][:numeric] = @highlight_numeric
            end

            unless @highlight_chars.empty?
              kwargs[:highlights][:chars] = @highlight_chars
            end
          end

          return kwargs
        end

      end
    end
  end
end

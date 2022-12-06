# frozen_string_literal: true
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
require 'ronin/cli/char_set_options'

module Ronin
  class CLI
    module Commands
      #
      # Finds all strings within a file/stream with a certain character set.
      #
      # ## Usage
      #
      #     ronin strings [options] [FILE ...]
      #
      # ## Options
      #
      #     -N, --numeric                    Searches for numeric characters (0-9)
      #     -O, --octal                      Searches for octal characters (0-7)
      #     -X, --upper-hex                  Searches for uppercase hexadecimal (0-9, A-F)
      #     -x, --lower-hex                  Searches for lowercase hexadecimal (0-9, a-f)
      #     -H, --hex                        Searches for hexadecimal chars (0-9, a-f, A-F)
      #         --upper-alpha                Searches for uppercase alpha chars (A-Z)
      #         --lower-alpha                Searches for lowercase alpha chars (a-z)
      #     -A, --alpha                      Searches for alpha chars (a-z, A-Z)
      #         --alpha-num                  Searches for alpha-numeric chars (a-z, A-Z, 0-9)
      #     -P, --punct                      Searches for punctuation chars
      #     -S, --symbols                    Searches for symbolic chars
      #     -s, --space                      Searches for all whitespace chars
      #     -v, --visible                    Searches for all visible chars
      #     -p, --printable                  Searches for all printable chars
      #     -C, --control                    Searches for all control chars (\x00-\x1f, \x7f)
      #     -a, --signed-ascii               Searches for all signed ASCII chars (\x00-\x7f)
      #         --ascii                      Searches for all ASCII chars (\x00-\xff)
      #     -c, --chars CHARS                Searches for all chars in the custom char-set
      #     -i, --include-chars CHARS        Include the additional chars to the char-set
      #     -e, --exclude-chars CHARS        Exclude the additional chars from the char-set
      #     -n, --min-length LEN             Minimum length of strings to print (Default: 4)
      #
      # ## Arguments
      #
      #     [FILE ...]                       The file(s) to read
      #
      # ## Examples
      #
      #     ronin strings --hex -n 32 file.bin
      #
      class Strings < FileProcessorCommand

        include CharSetOptions

        usage '[options] [FILE ...]'

        option :min_length, short: '-n',
                            value: {
                              type: Integer,
                              usage: 'LEN',
                              default: 4
                            },
                            desc: 'Minimum length of strings to print'

        option :null_byte, short: '-0',
                           desc: 'Print each string terminated with a null byte'

        argument :file, required: false,
                        repeats:  true,
                        desc:     'The file(s) to read'

        description 'Prints all strings within a file/stream belonging to the given character set'

        examples [
          '--hex -n 32 file.bin',
        ]

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
          super(file,'rb',&block)
        end

        #
        # Scans the input stream for printable strings.
        #
        # @param [IO, StringIO] input
        #   The input string.
        #
        def process_input(input)
          buffer     = String.new
          min_length = options[:min_length]

          input.each_char do |char|
            if @char_set.include_char?(char)
              buffer << char
            else
              print_buffer(buffer) if buffer.length >= min_length
              buffer.clear
            end
          end

          # print any remaining chars
          print_buffer(buffer) if buffer.length >= min_length
        end

        #
        # Prints a buffer to `STDOUT`.
        #
        # @param [String] buffer
        #
        def print_buffer(buffer)
          if options[:null_byte]
            stdout.write(buffer)
            putc("\0")
          else
            puts buffer
          end
        end

      end
    end
  end
end

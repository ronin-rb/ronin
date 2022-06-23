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

require 'command_kit/arguments/files'
require 'chars'

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
      class Strings < Command

        include CommandKit::Arguments::Files

        usage '[options] [FILE ...]'

        option :numeric, short: '-N',
                         desc: 'Searches for numeric characters (0-9)' do
                           @char_set = Chars::NUMERIC
                         end

        option :octal, short: '-O',
                       desc: 'Searches for octal characters (0-7)' do
                         @char_set = Chars::OCTAL
                       end

        option :upper_hex, short: '-X',
                           desc: 'Searches for uppercase hexadecimal (0-9, A-F)' do
                             @char_set = Chars::UPPERCASE_HEXADECIMAL
                           end

        option :lower_hex, short: '-x',
                           desc: 'Searches for lowercase hexadecimal (0-9, a-f)' do
                             @char_set = Chars::LOWERCASE_HEXADECIMAL
                           end

        option :hex, short: '-H',
                     desc: 'Searches for hexadecimal chars (0-9, a-f, A-F)' do
                       @char_set = Chars::HEXADECIMAL
                     end

        option :upper_alpha, desc: 'Searches for uppercase alpha chars (A-Z)' do
          @char_set = Chars::UPPERCASE_ALPHA
        end

        option :lower_alpha, desc: 'Searches for lowercase alpha chars (a-z)' do
          @char_set = Chars::LOWERCASE_ALPHA
        end

        option :alpha, short: '-A',
                       desc: 'Searches for alpha chars (a-z, A-Z)' do
                         @char_set = Chars::ALPHA
                       end

        option :alpha_num, desc: 'Searches for alpha-numeric chars (a-z, A-Z, 0-9)' do
          @char_set = Chars::ALPHA_NUMERIC
        end

        option :punct, short: '-P',
                       desc: 'Searches for punctuation chars' do
                         @char_set = Chars::PUNCTUATION
                       end

        option :symbols, short: '-S',
                         desc: 'Searches for symbolic chars' do
                           @char_set = Chars::SYMBOLS
                         end

        option :space, short: '-s',
                       desc: 'Searches for all whitespace chars' do
                         @char_set = Chars::SPACE
                       end

        option :visible, short: '-v',
                         desc: 'Searches for all visible chars' do
          @char_set = Chars::VISIBLE
        end

        option :printable, short: '-p',
                           desc: 'Searches for all printable chars' do
                             @char_set = Chars::PRINTABLE
                           end

        option :control, short: '-C',
                         desc: 'Searches for all control chars (\x00-\x1f, \x7f)' do
                           @char_set = Chars::CONTROL
                         end

        option :signed_ascii, short: '-a',
                              desc: 'Searches for all signed ASCII chars (\x00-\x7f)' do
                                @char_set = Chars::SIGNED_ASCII
                              end

        option :ascii, desc: 'Searches for all ASCII chars (\x00-\xff)' do
                         @char_set = Chars::ASCII
                       end

        option :chars, short: '-c',
                        value: {
                          type:  String,
                          usage: 'CHARS'
                        },
                        desc: 'Searches for all chars in the custom char-set' do |string|
                          @char_set = Chars::CharSet.new(*string.chars)
                        end

        option :include_chars, short: '-i',
                               value: {
                                 type: String,
                                 usage: 'CHARS',
                               },
                               desc: 'Include the additional chars to the char-set' do |string|
                                 @char_set += Chars::CharSet.new(*string.chars)
                               end

        option :exclude_chars, short: '-e',
                               value: {
                                 type:  String,
                                 usage: 'CHARS'
                               },
                               desc: 'Exclude the additional chars from the char-set' do |string|
                                 @char_set -= Chars::CharSet.new(*string.chars)
                               end

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
        # Initializes the `ronin strings` command.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @char_set = Chars::VISIBLE
        end

        #
        # Runs the `ronin strings` command.
        #
        # @param [Array<String>] files
        #   The optional files to process. If no files are given, then input
        #   will be read from `STDIN`.
        #
        def run(*files)
          buffer     = String.new
          min_length = options[:min_length]

          open_input_stream(*files) do |input|
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

            # clear the buffer before going to the next file
            buffer.clear
          end
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

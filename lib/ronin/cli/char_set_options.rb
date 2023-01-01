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

require 'chars'

module Ronin
  class CLI
    #
    # Adds common character set options to a command.
    #
    # ## Options
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
    #
    module CharSetOptions
      #
      # Adds common character set options to the command.
      #
      # @param [Class<Command>] command
      #   The command including {CharSetOptions}.
      #
      def self.included(command)
        command.option :numeric, short: '-N',
                         desc: 'Searches for numeric characters (0-9)' do
                           @char_set = Chars::NUMERIC
                         end

        command.option :octal, short: '-O',
                       desc: 'Searches for octal characters (0-7)' do
                         @char_set = Chars::OCTAL
                       end

        command.option :upper_hex, short: '-X',
                           desc: 'Searches for uppercase hexadecimal (0-9, A-F)' do
                             @char_set = Chars::UPPERCASE_HEXADECIMAL
                           end

        command.option :lower_hex, short: '-x',
                           desc: 'Searches for lowercase hexadecimal (0-9, a-f)' do
                             @char_set = Chars::LOWERCASE_HEXADECIMAL
                           end

        command.option :hex, short: '-H',
                     desc: 'Searches for hexadecimal chars (0-9, a-f, A-F)' do
                       @char_set = Chars::HEXADECIMAL
                     end

        command.option :upper_alpha, desc: 'Searches for uppercase alpha chars (A-Z)' do
          @char_set = Chars::UPPERCASE_ALPHA
        end

        command.option :lower_alpha, desc: 'Searches for lowercase alpha chars (a-z)' do
          @char_set = Chars::LOWERCASE_ALPHA
        end

        command.option :alpha, short: '-A',
                       desc: 'Searches for alpha chars (a-z, A-Z)' do
                         @char_set = Chars::ALPHA
                       end

        command.option :alpha_num, desc: 'Searches for alpha-numeric chars (a-z, A-Z, 0-9)' do
          @char_set = Chars::ALPHA_NUMERIC
        end

        command.option :punct, short: '-P',
                       desc: 'Searches for punctuation chars' do
                         @char_set = Chars::PUNCTUATION
                       end

        command.option :symbols, short: '-S',
                         desc: 'Searches for symbolic chars' do
                           @char_set = Chars::SYMBOLS
                         end

        command.option :space, short: '-s',
                       desc: 'Searches for all whitespace chars' do
                         @char_set = Chars::SPACE
                       end

        command.option :visible, short: '-v',
                         desc: 'Searches for all visible chars' do
          @char_set = Chars::VISIBLE
        end

        command.option :printable, short: '-p',
                           desc: 'Searches for all printable chars' do
                             @char_set = Chars::PRINTABLE
                           end

        command.option :control, short: '-C',
                         desc: 'Searches for all control chars (\x00-\x1f, \x7f)' do
                           @char_set = Chars::CONTROL
                         end

        command.option :signed_ascii, short: '-a',
                              desc: 'Searches for all signed ASCII chars (\x00-\x7f)' do
                                @char_set = Chars::SIGNED_ASCII
                              end

        command.option :ascii, desc: 'Searches for all ASCII chars (\x00-\xff)' do
                         @char_set = Chars::ASCII
                       end

        command.option :chars, short: '-c',
                        value: {
                          type:  String,
                          usage: 'CHARS'
                        },
                        desc: 'Searches for all chars in the custom char-set' do |string|
                          @char_set = Chars::CharSet.new(*string.chars)
                        end

        command.option :include_chars, short: '-i',
                               value: {
                                 type: String,
                                 usage: 'CHARS',
                               },
                               desc: 'Include the additional chars to the char-set' do |string|
                                 @char_set += Chars::CharSet.new(*string.chars)
                               end

        command.option :exclude_chars, short: '-e',
                               value: {
                                 type:  String,
                                 usage: 'CHARS'
                               },
                               desc: 'Exclude the additional chars from the char-set' do |string|
                                 @char_set -= Chars::CharSet.new(*string.chars)
                               end
      end

      # The set character set.
      attr_reader :char_set

      #
      # Initializes the command.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      def initialize(**kwargs)
        super(**kwargs)

        @char_set = Chars::VISIBLE
      end
    end
  end
end

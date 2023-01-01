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

require 'ronin/cli/value_processor_command'
require 'ronin/cli/char_set_options'
require 'ronin/support/binary/core_ext/string'
require 'ronin/support/encoding/hex'

require 'chars'

module Ronin
  class CLI
    module Commands
      #
      # Prints every bit-flip of the given string(s).
      #
      # ## Usage
      #
      #     ronin bitflip [options] [STRING ...]
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
      #         --prepend STRING             Prepends the given string to each output
      #         --append STRING              Appends the given string to each output
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [STRING ...]                     The string(s) to bit-flip.
      #
      # ## Examples
      #
      #     ronin bitflip --prepend www --append .com microsoft
      #
      class Bitflip < ValueProcessorCommand

        include CharSetOptions

        usage '[options] [STRING ...]'

        option :prepend, value: {
                           type:  String,
                           usage: 'STRING'
                         },
                         desc: 'Prepends the given string to each output'

        option :append, value: {
                          type:  String,
                          usage: 'STRING'
                        },
                        desc: 'Appends the given string to each output'

        argument :string, required: false,
                          repeats:  true,
                          desc:     'The string(s) to bitflip'

        description "Prints every bit-flip of the given string(s)"

        man_page 'ronin-bitflip.1'

        #
        # Prints every bit-flip of a given String.
        #
        # @param [String] string
        #
        def process_value(string)
          string.each_bit_flip do |bit_flipped|
            if @char_set =~ bit_flipped
              puts format_string(bit_flipped)
            end
          end
        end

        #
        # Formats a bit-fipped string.
        #
        # @param [String] string
        #   The bit-flipped String.
        #
        # @return [String]
        #   The formatted bit-flipped String.
        #
        def format_string(string)
          string.prepend(options[:prepend]) if options[:prepend]
          string.concat(options[:append])   if options[:append]

          if string =~ /\A[[:print:]]+\z/
            string
          else
            Support::Encoding::Hex.escape(string)
          end
        end

      end
    end
  end
end

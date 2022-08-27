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

require 'ronin/cli/string_processor_command'

require 'ronin/support/crypto'

module Ronin
  class CLI
    module Commands
      #
      # Rotates each character of data within an alphabet.
      #
      # ## Usage
      #
      #     ronin rot [options] [FILE ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process.
      #     -M, --multiline                  Process each line separately
      #         --keep-newlines              Preserves newlines at the end of each line
      #     -A, --alphabet ABC...            Alphabet characters
      #     -n, --modulu NUM                 Number of characters to rotate
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [STRING ...]                     Optional string value(s) to process
      #
      class Rot < StringProcessorCommand

        option :alphabet, short: '-A',
                          value: {
                            type: String,
                            usage: 'ABC...'
                          },
                          desc: 'Alphabet characters' do |str|
                            @alphabets << str.chars
                          end

        option :modulu, short: '-n',
                        value: {
                          type:  Integer,
                          usage: 'NUM'
                        },
                        desc: 'Number of characters to rotate' do |num|
                          @n = num
                        end

        description "Rotates each character of data within an alphabet"

        man_page 'ronin-rot.1'

        # The number of characters to rotate.
        #
        # @return [Integer]
        attr_reader :n

        # The alphabets to rotate within.
        #
        # @return [Array<Array<String>>]
        attr_reader :alphabets

        #
        # Initializes the `ronin rot` command.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keywords.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @n = 13
          @alphabets = []
        end

        #
        # Rotates each character in the string.
        #
        # @param [String] string
        #   The input string.
        #
        # @return [String]
        #   The rotated string.
        #
        def process_string(string)
          if !@alphabets.empty?
            Support::Crypto.rot(string,@n, alphabets: @alphabets)
          else
            Support::Crypto.rot(string,@n)
          end
        end

      end
    end
  end
end

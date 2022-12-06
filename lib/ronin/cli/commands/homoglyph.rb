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

require 'ronin/cli/value_processor_command'

require 'ronin/support/text/homoglyph'

module Ronin
  class CLI
    module Commands
      #
      # Generates homoglyph equivalent words.
      #
      # ## Usage
      #
      #     ronin homoglyph [options] [WORD ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #     -C ascii|greek|cyrillic|punctuation|latin_numbers|full_width,
      #         --char-set                   Selects the homoglyph character set
      #     -E, --enum                       Enumerates over every possible typo of a word
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [WORD ...]                       Optional word(s) to homoglyph
      #
      class Homoglyph < ValueProcessorCommand

        option :char_set, short: '-C',
                          value: {
                            type: [
                              :ascii, :greek, :cyrillic, :punctuation,
                              :latin_numbers, :full_width
                            ]
                          },
                          desc: 'Selects the homoglyph character set'

        option :enum, short: '-E',
                      desc:  'Enumerates over every possible typo of a word'

        argument :word, repeats:  true,
                        required: false,
                        desc:     'Optional word(s) to homoglyph'

        description 'Generates homoglyph equivalent words'

        man_page 'ronin-homoglyph.1'

        #
        # Runs the `ronin homoglyph` command.
        #
        # @param [Array<String>] words
        #   The words to homoglyph.
        #
        def run(*words)
          @table = Support::Text::Homoglyph.table(options[:char_set])

          super(*words)
        end

        #
        # Processes each word.
        #
        # @param [String] word
        #   A word argument to homoglyph.
        #
        def process_value(word)
          if options[:enum]
            @table.each_substitution(word) do |homoglyphed_word|
              puts homoglyphed_word
            end
          else
            puts @table.substitute(word)
          end
        end

      end
    end
  end
end

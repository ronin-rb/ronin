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

require 'ronin/support/text/typo'

module Ronin
  class CLI
    module Commands
      #
      # Generates typos in words.
      #
      # ## Usage
      #
      #     ronin typo [options] [WORD ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #         --omit-chars                 Toggles whether to omit repeated characters
      #         --repeat-chars               Toggles whether to repeat single characters
      #         --swap-chars                 Toggles whether to swap certain common character pairs
      #         --change-suffix              Toggles whether to change the suffix of words
      #     -E, --enumerate                  Enumerates over every possible typo of a word
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [WORD ...]                       Optional word(s) to typo
      #
      class Typo < ValueProcessorCommand

        option :omit_chars, desc: 'Toggles whether to omit repeated characters' do
          @typo_kwargs[:emit_chars] = true
        end

        option :repeat_chars, desc: 'Toggles whether to repeat single characters' do
          @typo_kwargs[:repeat_chars] = true
        end

        option :swap_chars, desc: 'Toggles whether to swap certain common character pairs' do
          @typo_kwargs[:swap_chars] = true
        end

        option :change_suffix, desc: 'Toggles whether to change the suffix of words' do
          @typo_kwargs[:change_suffix] = true
        end

        option :enumerate, short: '-E',
                           desc:  'Enumerates over every possible typo of a word'

        argument :word, repeats:  true,
                        required: false,
                        desc:     'Optional word(s) to typo'

        description 'Generates typos in words'

        man_page 'ronin-typo.1'

        #
        # Initializes the command.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @typo_kwargs = {}
        end

        #
        # Runs the `ronin typo` command.
        #
        # @param [Array<String>] words
        #   The words to typo.
        #
        def run(*words)
          @generator = Support::Text::Typo.generator(**@typo_kwargs)

          super(*words)
        end

        #
        # Processes each word.
        #
        # @param [String] word
        #   A word argument to typo.
        #
        def process_value(word)
          if options[:enumerate]
            @generator.each_substitution(word) do |typo|
              puts typo
            end
          else
            puts @generator.substitute(word)
          end
        end

      end
    end
  end
end

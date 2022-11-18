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

require 'ronin/support/text/typo'

module Ronin
  class CLI
    #
    # Adds options for enabling typo generator rules.
    #
    # ## Options
    #
    #         --omit-chars                 Toggles whether to omit repeated characters
    #         --repeat-chars               Toggles whether to repeat single characters
    #         --swap-chars                 Toggles whether to swap certain common character pairs
    #         --change-suffix              Toggles whether to change the suffix of words
    #
    module TypoOptions
      #
      # Adds typo options to the command.
      #
      # @param [Class<Command>] command
      #   The command including {TypoOptions}.
      #
      def self.included(command)
        command.option :omit_chars, desc: 'Toggles whether to omit repeated characters' do
          @typo_kwargs[:emit_chars] = true
        end

        command.option :repeat_chars, desc: 'Toggles whether to repeat single characters' do
          @typo_kwargs[:repeat_chars] = true
        end

        command.option :swap_chars, desc: 'Toggles whether to swap certain common character pairs' do
          @typo_kwargs[:swap_chars] = true
        end

        command.option :change_suffix, desc: 'Toggles whether to change the suffix of words' do
          @typo_kwargs[:change_suffix] = true
        end
      end

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
      # The typo generator.
      #
      # @return [Ronin::Support::Text::Typo::Generator]
      #
      def typo_generator
        @type_generator ||= Support::Text::Typo.generator(**@typo_kwargs)
      end
    end
  end
end

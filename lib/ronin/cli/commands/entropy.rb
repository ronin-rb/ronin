# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative '../file_processor_command'

require 'ronin/support/text/patterns'
require 'ronin/support/text/entropy'

module Ronin
  class CLI
    module Commands
      #
      # Filters lines by their entropy.
      #
      # ## Usage
      #
      #     ronin entropy [options] [FILE ...]
      #
      # ## Options
      #
      #     -e, --entropy DEC                Minimum required entropy (Default: 4.0)
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to process
      #
      class Entropy < FileProcessorCommand

        option :entropy, short: '-e',
                         value: {
                           type:    Float,
                           default: 4.0
                         },
                         desc: 'Minimum required entropy'

        description "Filters lines by their entropy"

        man_page 'ronin-entropy.1'

        #
        # Filters the input stream for high-entropy strings.
        #
        # @param [IO, StringIO] input
        #   The input stream to grep.
        #
        def process_input(input)
          entropy = options[:entropy]

          input.each_line(chomp: true) do |line|
            if Support::Text::Entropy.calculate(line) > entropy
              puts line
            end
          end
        end

      end
    end
  end
end

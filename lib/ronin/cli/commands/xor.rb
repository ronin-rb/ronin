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

require 'ronin/cli/string_command'
require 'ronin/cli/key_options'

require 'ronin/support/crypto'

module Ronin
  class CLI
    module Commands
      #
      # XORs each character of data with a key.
      #
      # ## Usage
      #
      #     ronin xor [options] [STRING ... | -i FILE]
      #
      # ## Options
      #
      #     -i, --input FILE                 Optional input file
      #     -o, --output FILE                Optional output file
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -k, --key STRING                 The key String
      #     -K, --key-file FILE              The key file
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [STRING ...]                     Optional string value(s) to process
      #
      class Xor < StringCommand

        include KeyOptions

        description "XORs each character of data with a key."

        man_page 'ronin-xor.1'

        #
        # XORs the string.
        #
        # @param [String] string
        #   The input string.
        #
        # @return [String]
        #   The XORed string.
        #
        def process_string(string)
          xored_string = Support::Crypto.xor(string,@key)

          # escapes the String if outputing to a TTY
          xored_string = xored_string.dump if output_stream.tty?
          return xored_string
        end

      end
    end
  end
end

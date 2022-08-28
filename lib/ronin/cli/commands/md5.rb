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

require 'digest'

module Ronin
  class CLI
    module Commands
      #
      # Calculates MD5 hashes of data.
      #
      # ## Usage
      #
      #     ronin md5 [options] [FILE ...]
      #
      # ## Options
      #
      #     -i, --file FILE                  Optional file to process.
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to process
      #
      class Md5 < StringProcessorCommand

        description "Calculates MD5 hashes of data"

        man_page 'ronin-md5.1'

        #
        # Computes a MD5 checksum for the given String.
        #
        # @param [String] string
        #   The input string.
        #
        # @return [String]
        #   The MD5 hexdigest of the given String.
        #
        def process_string(string)
          Digest::MD5.hexdigest(string)
        end

      end
    end
  end
end

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

require 'ronin/cli/string_processor_command'
require 'ronin/cli/key_options'

require 'ronin/support/crypto'

module Ronin
  class CLI
    module Commands
      #
      # Calculates a [Hash-based Message Authentication Code (HMAC)][HMAC] for
      # data.
      #
      # [HMAC]: https://en.wikipedia.org/wiki/HMAC
      #
      # ## Usage
      #
      #     ronin hmac [options] [FILE ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #         --string STRING              Optional string to process
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -H md5|sha1|sha256|sha512,       Hash algorithm to use (Default: sha1)
      #         --hash
      #     -k, --key STRING                 The key String
      #     -K, --key-file FILE              The key file
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to process
      #
      class Hmac < StringProcessorCommand

        include KeyOptions

        option :hash, short: '-H',
                      value: {
                        type:    [:md5, :sha1, :sha256, :sha512],
                        default: :sha1,
                      },
                      desc: 'Hash algorithm to use'

        description "Calculates a Hash-based Message Authentication Code (HMAC)"

        man_page 'ronin-hmac.1'

        #
        # Runs the `ronin hmac` command.
        #
        # @param [Array<String>] files
        #   Additional files to process.
        #
        def run(*files)
          unless @key
            print_error "must specify --key or --key-file"
            exit(-1)
          end

          super(*files)
        end

        #
        # Calculates the Hash-based Message Authentication Code (HMAC) for the
        # given string.
        #
        # @param [String] string
        #   The input string.
        #
        # @return [String]
        #   The HMAC string.
        #
        def process_string(string)
          hmac = Support::Crypto.hmac(string, key:    self.key,
                                              digest: options[:hash])
          hmac.hexdigest
        end

      end
    end
  end
end

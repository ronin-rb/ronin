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

require 'ronin/cli/file_processor_command'
require 'ronin/cli/pattern_options'

module Ronin
  class CLI
    module Commands
      #
      # Extract common patterns from a file/stream.
      #
      # ## Usage
      #
      #     ronin extract [options] [FILE ...]
      #
      # ## Options
      #
      #     -N, --number                     Searches for all numbers
      #     -X, --hex-number                 Searches for all numbers
      #     -w, --word                       Searches for all words
      #         --mac-addr                   Searches for all MAC addresses
      #     -4, --ipv4-addr                  Searches for all IPv4 addresses
      #     -6, --ipv6-addr                  Searches for all IPv6 addresses
      #     -I, --ip                         Searches for all IP addresses
      #     -H, --host                       Searches for all host names
      #     -D, --domain                     Searches for all domain names
      #         --uri                        Searches for all URIs
      #     -U, --url                        Searches for all URLs
      #         --user-name                  Searches for all user names
      #     -E, --email-addr                 Searches for all email addresses
      #         --obfuscated-email-addr      Searches for all obfuscated email addresses
      #         --phone-number               Searches for all phone numbers
      #         --ssn                        Searches for all Social Security Numbers (SSNs)
      #         --amex-cc                    Searches for all AMEX Credit Card numbers
      #         --discover-cc                Searches for all Discord Card numbers
      #         --mastercard-cc              Searches for all MasterCard numbers
      #         --visa-cc                    Searches for all VISA Credit Card numbers
      #         --visa-mastercard-cc         Searches for all VISA MasterCard numbers
      #         --cc                         Searches for all Credit Card numbers
      #         --file-name                  Searches for all file names
      #         --dir-name                   Searches for all directory names
      #         --relative-unix-path         Searches for all relative UNIX paths
      #         --absolute-unix-path         Searches for all absolute UNIX paths
      #         --unix-path                  Searches for all UNIX paths
      #         --relative-windows-path      Searches for all relative Windows paths
      #         --absolute-windows-path      Searches for all absolute Windows paths
      #         --windows-path               Searches for all Windows paths
      #         --relative-path              Searches for all relative paths
      #         --absolute-path              Searches for all absolute paths
      #     -P, --path                       Searches for all paths
      #         --variable-name              Searches for all variable names
      #         --function-name              Searches for all function names
      #         --md5                        Searches for all MD5 hashes
      #         --sha1                       Searches for all SHA1 hashes
      #         --sha256                     Searches for all SHA256 hashes
      #         --sha512                     Searches for all SHA512 hashes
      #         --hash                       Searches for all hashes
      #         --ssh-private-key            Searches for all SSH private key data
      #         --ssh-public-key             Searches for all SSH public key data
      #         --private-key                Searches for all private key data
      #         --rsa-public-key             Searches for all RSA public key data
      #         --dsa-public-key             Searches for all DSA public key data
      #         --ec-public-key              Searches for all EC public key data
      #         --public-key                 Searches for all public key data
      #         --single-quoted-string       Searches for all single-quoted strings
      #         --double-quoted-string       Searches for all double-quoted strings
      #     -S, --string                     Searches for all quoted strings
      #     -B, --base64                     Searches for all Base64 strings
      #     -e, --regexp /REGEXP/            Custom regular expression to search for
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional input file(s)
      #
      class Extract < FileProcessorCommand

        include PatternOptions

        usage '[options] [FILE ...]'

        description 'Extracts common patterns from files/input'

        man_page 'ronin-extract.1'

        #
        # Runs the `extract` sub-command.
        #
        # @param [Array<String>] files
        #   Additional file arguments.
        #
        def run(*files)
          unless @pattern
            print_error "must specify a pattern to search for"
            exit -1
          end

          super(*files)
        end

        #
        # Extracts the pattern from the input stream.
        #
        # @parma [IO, StringIO] input
        #   The input stream to process.
        #
        def process_input(input)
          input.each_line(chomp: true) do |line|
            line.scan(@pattern) do |match|
              puts match
            end
          end
        end

      end
    end
  end
end

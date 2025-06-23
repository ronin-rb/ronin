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
require_relative '../pattern_options'

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
      #     -X, --hex-number                 Searches for all hexadecimal numbers
      #     -V, --version-number             Searches for all version numbers
      #         --alpha                      Searches for all alphabetic characters
      #         --uppercase                  Searches for all uppercase alphabetic characters
      #         --lowercase                  Searches for all lowercase alphabetic characters
      #         --alpha-numeric              Searches for all alphanumeric characters
      #         --hex                        Searches for all hexadecimal characters
      #         --uppercase-hex              Searches for all uppercase hexadecimal characters
      #         --lowercase-hex              Searches for all lowercase hexadecimal characters
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
      #         --discover-cc                Searches for all Discover Card numbers
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
      #         --identifier                 Searches for all identifier names
      #         --variable-name              Searches for all variable names
      #         --variable-assignment        Searches for all variable assignments
      #         --function-name              Searches for all function names
      #         --md5                        Searches for all MD5 hashes
      #         --sha1                       Searches for all SHA1 hashes
      #         --sha256                     Searches for all SHA256 hashes
      #         --sha512                     Searches for all SHA512 hashes
      #         --hash                       Searches for all hashes
      #         --ssh-private-key            Searches for all SSH private key data
      #         --dsa-private-key            Searches for all DSA private key data
      #         --ec-private-key             Searches for all EC private key data
      #         --rsa-private-key            Searches for all RSA private key data
      #     -K, --private-key                Searches for all private key data
      #         --ssh-public-key             Searches for all SSH public key data
      #         --public-key                 Searches for all public key data
      #         --aws-access-key-id          Searches for all AWS access key IDs
      #         --aws-secret-access-key      Searches for all AWS secret access keys
      #     -A, --api-key                    Searches for all API keys
      #         --single-quoted-string       Searches for all single-quoted strings
      #         --double-quoted-string       Searches for all double-quoted strings
      #     -S, --string                     Searches for all quoted strings
      #     -B, --base64                     Searches for all Base64 strings
      #         --c-comment                  Searches for all C comments
      #         --cpp-comment                Searches for all C++ comments
      #         --java-comment               Searches for all Java comments
      #         --javascript-comment         Searches for all JavaScript comments
      #         --shell-comment              Searches for all Shell comments
      #         --ruby-comment               Searches for all Ruby comments
      #         --python-comment             Searches for all Python comments
      #         --comment                    Searches for all comments
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
            exit(-1)
          end

          super(*files)
        end

        #
        # Extracts the pattern from the input stream.
        #
        # @param [IO, StringIO] input
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

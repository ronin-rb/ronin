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

require 'command_kit/colors'

module Ronin
  class CLI
    module Commands
      #
      # Greps for common patterns in a file/stream.
      #
      # ## Usage
      #
      #     ronin grep [options] [FILE ...]
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
      #     -o, --only-matching              Only print the matching data
      #     -n, --line-number                Print the line number for each line
      #         --with-filename              Print the file name for each match
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional input file(s)
      #
      class Grep < FileProcessorCommand

        include PatternOptions
        include CommandKit::Colors

        usage '[options] [FILE ...]'

        option :only_matching, short: '-o',
                               desc: 'Only print the matching data'

        option :line_number, short: '-n',
                              desc: 'Print the line number for each line'

        option :with_filename, desc: 'Print the file name for each match'

        description 'Searches files/input for common patterns'

        man_page 'ronin-grep.1'

        #
        # Runs the `ronin grep` command.
        #
        # @param [Array<String>] files
        #   Additional file arguments to grep.
        #
        def run(*files)
          unless @pattern
            print_error "must specify a pattern to search for"
            exit(-1)
          end

          super(*files)
        end

        #
        # Greps the input stream.
        #
        # @param [IO, StringIO] input
        #   The input stream to grep.
        #
        def process_input(input)
          filename = filename_of(input)

          input.each_line(chomp: true).with_index do |line,index|
            match_line(line, filename: filename, line_number: index + 1)
          end
        end

        #
        # Returns the file name for the IO stream.
        #
        # @param [File, IO] io
        #
        # @return [String]
        #
        def filename_of(io)
          case io
          when File then io.path
          else           '[stdin]'
          end
        end

        #
        # Attempts to match a line of text.
        #
        # @param [String] line
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        # @option kwargs [String] :filename
        #
        # @option kwargs [Integer] :line_number
        #
        def match_line(line,**kwargs)
          index = 0

          printed_prefix = false
          only_matching  = options[:only_matching]

          while (match = line.match(@pattern,index))
            unless printed_prefix
              print_line_prefix(**kwargs)
              printed_prefix = true
            end

            match_start, match_stop = match.offset(0)

            # print the text before the match, unless --only-matching is enabled
            print(line[index...match_start]) unless only_matching
            print_match(match)

            index = match_stop
          end

          unless only_matching
            # print the rest of the line, if we've had at least one match
            puts(line[index..]) if index > 0
          end
        end

        #
        # Optionally prints the filename or line-number prefix for a line.
        #
        # @param [String] filename
        #
        # @param [Integer] line_number
        #
        def print_line_prefix(filename: , line_number: )
          if options[:with_filename]
            print colors.magenta(filename)
            print colors.cyan(':')
          end

          if options[:line_numbers]
            print colors.green(line_number)
            print colors.cyan(':')
          end
        end

        #
        # Prints the matched string w/o ANSI highlighting.
        #
        # @param [String] match
        #
        def print_match(match)
          match_string = match[0]
          highlighted  = colors.bold(colors.red(match_string))

          if options[:only_matching]
            puts highlighted
          else
            print highlighted
          end
        end

      end
    end
  end
end

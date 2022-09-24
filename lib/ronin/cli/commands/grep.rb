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
require 'ronin/support/text/patterns'

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
      #     -N, --number                     Grep for all numbers
      #     -X, --hex-number                 Grep for all numbers
      #     -w, --word                       Grep for all words
      #         --mac-addr                   Grep for all MAC addresses
      #     -4, --ipv4-addr                  Grep for all IPv4 addresses
      #     -6, --ipv6-addr                  Grep for all IPv6 addresses
      #     -I, --ip                         Grep for all IP addresses
      #     -H, --host                       Grep for all host names
      #     -D, --domain                     Grep for all domain names
      #     -U, --url                        Grep for all URLs
      #         --user-name                  Grep for all user names
      #     -E, --email-addr                 Grep for all email addresses
      #         --phone-number               Grep for all phone numbers
      #         --ssn                        Grep for all Social Security Numbers (SSNs)
      #         --amex-cc                    Grep for all AMEX Credit Card numbers
      #         --discover-cc                Grep for all Discord Card numbers
      #         --mastercard-cc              Grep for all MasterCard numbers
      #         --visa-cc                    Grep for all VISA Credit Card numbers
      #         --visa-mastercard-cc         Grep for all VISA MasterCard numbers
      #         --cc                         Grep for all Credit Card numbers
      #         --file-name                  Grep for all file names
      #         --dir-name                   Grep for all directory names
      #         --relative-unix-path         Grep for all relative UNIX paths
      #         --absolute-unix-path         Grep for all absolute UNIX paths
      #         --unix-path                  Grep for all UNIX paths
      #         --relative-windows-path      Grep for all relative Windows paths
      #         --absolute-windows-path      Grep for all absolute Windows paths
      #         --windows-path               Grep for all Windows paths
      #         --relative-path              Grep for all relative paths
      #         --absolute-path              Grep for all absolute paths
      #     -P, --path                       Grep for all paths
      #         --variable-name              Grep for all variable names
      #         --function-name              Grep for all function names
      #         --md5                        Grep for all MD5 hashes
      #         --sha1                       Grep for all SHA1 hashes
      #         --sha256                     Grep for all SHA256 hashes
      #         --sha512                     Grep for all SHA512 hashes
      #         --hash                       Grep for all hashes
      #         --ssh-private-key            Grep for all SSH private key data
      #         --ssh-public-key             Grep for all SSH public key data
      #         --private-key                Grep for all private key data
      #         --rsa-public-key             Grep for all RSA public key data
      #         --dsa-public-key             Grep for all DSA public key data
      #         --ec-public-key              Grep for all EC public key data
      #         --public-key                 Grep for all public key data
      #         --single-quoted-string       Grep for all single-quoted strings
      #         --double-quoted-string       Grep for all double-quoted strings
      #     -S, --string                     Grep for all quoted strings
      #     -B, --base64                     Grep for all Base64 strings
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

        include CommandKit::Colors
        include Support::Text::Patterns

        usage '[options] [FILE ...]'

        option :number, short: '-N',
                         desc: 'Grep for all numbers' do
                           @pattenr = NUMBER
                         end

        option :hex_number, short: '-X',
                             desc: 'Grep for all numbers' do
                               @pattenr = NUMBER
                             end

        option :word, short: '-w',
                       desc: 'Grep for all words' do
                         @pattern = WORD
                       end

        option :mac_addr, desc: 'Grep for all MAC addresses' do
          @pattern = MAC_ADDR
        end

        option :ipv4_addr, short: '-4',
                            desc: 'Grep for all IPv4 addresses' do
                              @pattern = IPV4_ADDR
                            end

        option :ipv6_addr, short: '-6',
                            desc: 'Grep for all IPv6 addresses' do
                              @pattern = IPV6_ADDR
                            end

        option :ip, short: '-I',
                     desc: 'Grep for all IP addresses' do
                       @pattern = IP
                     end

        option :host, short: '-H',
                       desc: 'Grep for all host names' do
                         @pattern = HOST_NAME
                       end

        option :domain, short: '-D',
                         desc: 'Grep for all domain names' do
                           @pattern = DOMAIN
                         end

        option :url, short: '-U',
                      desc: 'Grep for all URLs' do
                        @pattern = URL
                      end

        option :user_name, desc: 'Grep for all user names' do
          @pattern = USER_NAME
        end

        option :email_addr, short: '-E',
                             desc: 'Grep for all email addresses' do
                               @pattern = EMAIL_ADDRESS
                             end

        option :phone_number, desc: 'Grep for all phone numbers' do
          @pattern = PHONE_NUMBER
        end

        option :ssn, desc: 'Grep for all Social Security Numbers (SSNs)' do
          @pattern = SSN
        end

        option :amex_cc, desc: 'Grep for all AMEX Credit Card numbers' do
          @pattern = AMEX_CC
        end

        option :discover_cc, desc: 'Grep for all Discord Card numbers' do
          @pattern = DISCOVER_CC
        end

        option :mastercard_cc, desc: 'Grep for all MasterCard numbers' do
          @pattern = MASTERCARD_CC
        end

        option :visa_cc, desc: 'Grep for all VISA Credit Card numbers' do
          @pattern = VISA_CC
        end

        option :visa_mastercard_cc, desc: 'Grep for all VISA MasterCard numbers' do
          @pattern = VISA_MASTERCARD_CC
        end

        option :cc, desc: 'Grep for all Credit Card numbers' do
          @pattern = CC
        end

        option :file_name, desc: 'Grep for all file names' do
          @pattern = FILE_NAME
        end

        option :dir_name, desc: 'Grep for all directory names' do
          @pattern = DIR_NAME
        end

        option :relative_unix_path, desc: 'Grep for all relative UNIX paths' do
          @pattern = RELATIVE_UNIX_PATH
        end

        option :absolute_unix_path, desc: 'Grep for all absolute UNIX paths' do
          @pattern = ABSOLUTE_UNIX_PATH
        end

        option :unix_path, desc: 'Grep for all UNIX paths' do
          @pattern = UNIX_PATH
        end

        option :relative_windows_path, desc: 'Grep for all relative Windows paths' do
          @pattern = RELATIVE_WINDOWS_PATH
        end

        option :absolute_windows_path, desc: 'Grep for all absolute Windows paths' do
          @pattern = ABSOLUTE_WINDOWS_PATH
        end

        option :windows_path, desc: 'Grep for all Windows paths' do
          @pattern = WINDOWS_PATH
        end

        option :relative_path, desc: 'Grep for all relative paths' do
          @pattern = RELATIVE_PATH
        end

        option :absolute_path, desc: 'Grep for all absolute paths' do
          @pattern = ABSOLUTE_PATHS
        end

        option :path, short: '-P',
          desc: 'Grep for all paths' do
            @pattern = PATH
          end

        option :variable_name, desc: 'Grep for all variable names' do
          @pattern = VARIABLE_NAME
        end

        option :function_name, desc: 'Grep for all function names' do
          @pattern = FUNCTION_NAMES
        end

        option :md5, desc: 'Grep for all MD5 hashes' do
          @pattern = MD5
        end

        option :sha1, desc: 'Grep for all SHA1 hashes' do
          @pattern = SHA1
        end

        option :sha256, desc: 'Grep for all SHA256 hashes' do
          @pattern = SHA256
        end

        option :sha512, desc: 'Grep for all SHA512 hashes' do
          @pattern = SHA512
        end

        option :hash, desc: 'Grep for all hashes' do
          @pattern = HASH
        end

        option :ssh_private_key, desc: 'Grep for all SSH private key data' do
          @pattern = SSH_PRIVATE_KEY
        end

        option :ssh_public_key, desc: 'Grep for all SSH public key data' do
          @pattern = SSH_PUBLIC_KEY
        end

        option :private_key, desc: 'Grep for all private key data' do
          @pattern = PRIVATE_KEY
        end

        option :rsa_public_key, desc: 'Grep for all RSA public key data' do
          @pattern = RSA_PUBLIC_KEY
        end

        option :dsa_public_key, desc: 'Grep for all DSA public key data' do
          @pattern = DSA_PUBLIC_KEY
        end

        option :ec_public_key, desc: 'Grep for all EC public key data' do
          @pattern = EC_PUBLIC_KEY
        end

        option :ssh_public_key, desc: 'Grep for all SSH public key data' do
          @pattern = SSH_PUBLIC_KEY
        end

        option :public_key, desc: 'Grep for all public key data' do
          @pattern = PUBLIC_KEY
        end

        option :single_quoted_string,  desc: 'Grep for all single-quoted strings' do
          @pattern = SINGLE_QUOTED_STRING
        end

        option :double_quoted_string,  desc: 'Grep for all double-quoted strings' do
          @pattern = DOUBLE_QUOTED_STRING
        end

        option :string, short: '-S',
                         desc: 'Grep for all quoted strings' do
                           @pattern = STRING
                         end

        option :base64, short: '-B',
                        desc: 'Grep for all Base64 strings' do
                          @pattern = BASE64
                        end

        option :regexp, short: '-e',
                        value: {type: Regexp},
                        desc: 'Custom regular expression to search for' do |regexp|
                          @pattern = regexp
                        end

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
            exit -1
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

          input.each_line(chomp: true).each_with_index do |line,index|
            match_line(line, filename: filename, line_number: index+1)
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

          while (match = line.match(@pattern,index))
            unless printed_prefix
              print_line_prefix(**kwargs)
              printed_prefix = true
            end

            match_start, match_stop = match.offset(0)

            # print the text before the match, unless --only-matching is enabled
            print(line[index...match_start]) unless options[:only_matching]
            print_match(match)

            index = match_stop
          end

          unless options[:only_matching]
            # print the rest of the line, if we've had at least one match
            puts(line[index..]) if index > 0
          end
        end

        #
        # Optionally prints the filename or linenumber prefix for a line.
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

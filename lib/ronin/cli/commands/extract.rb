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

require 'ronin/cli/command'
require 'ronin/support/text/patterns'

require 'command_kit/arguments/files'

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
      #     -N, --number                     Extract all numbers
      #     -X, --hex-number                 Extract all numbers
      #     -w, --word                       Extract all words
      #         --mac-addr                   Extract all MAC addresses
      #     -4, --ipv4-addr                  Extract all IPv4 addresses
      #     -6, --ipv6-addr                  Extract all IPv6 addresses
      #     -I, --ip                         Extract all IP addresses
      #     -H, --host                       Extract all host names
      #     -D, --domain                     Extract all domain names
      #     -U, --url                        Extract all URLs
      #         --user-name                  Extract all user names
      #     -E, --email-addr                 Extract all email addresses
      #         --phone-number               Extract all phone numbers
      #         --ssn                        Extract all Social Security Numbers (SSNs)
      #         --file-name                  Extract all file names
      #         --dir-name                   Extract all directory names
      #         --relative-unix-path         Extract all relative UNIX paths
      #         --absolute-unix-path         Extract all absolute UNIX paths
      #         --unix-path                  Extract all UNIX paths
      #         --relative-windows-path      Extract all relative Windows paths
      #         --absolute-windows-path      Extract all absolute Windows paths
      #         --windows-path               Extract all Windows paths
      #         --relative-path              Extract all relative paths
      #         --absolute-path              Extract all absolute paths
      #     -P, --path                       Extract all paths
      #         --variable-name              Extract all variable names
      #         --function-name              Extract all function names
      #         --md5                        Extract all MD5 hashes
      #         --sha1                       Extract all SHA1 hashes
      #         --sha256                     Extract all SHA256 hashes
      #         --sha512                     Extract all SHA512 hashes
      #         --hash                       Extract all hashes
      #         --ssh-private-key            Extract all SSH private key data
      #         --ssh-public-key             Extract all SSH public key data
      #         --private-key                Extract all private key data
      #         --rsa-public-key             Extract all RSA public key data
      #         --dsa-public-key             Extract all DSA public key data
      #         --ec-public-key              Extract all EC public key data
      #         --public-key                 Extract all public key data
      #         --single-quoted-string       Extract all single-quoted strings
      #         --double-quoted-string       Extract all double-quoted strings
      #     -S, --string                     Extract all quoted strings
      #     -B, --base64                     Extract all Base64 strings
      #     -e, --regexp /REGEXP/            Custom regular expression to search for
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional input file(s)
      #
      class Extract < Command

        include CommandKit::Arguments::Files
        include Support::Text::Patterns

        usage '[options] [FILE ...]'

        option :number, short: '-N',
                         desc: 'Extract all numbers' do
                           @pattenr = NUMBER
                         end

        option :hex_number, short: '-X',
                             desc: 'Extract all numbers' do
                               @pattenr = NUMBER
                             end

        option :word, short: '-w',
                       desc: 'Extract all words' do
                         @pattern = WORD
                       end

        option :mac_addr, desc: 'Extract all MAC addresses' do
          @pattern = MAC_ADDR
        end

        option :ipv4_addr, short: '-4',
                            desc: 'Extract all IPv4 addresses' do
                              @pattern = IPV4_ADDR
                            end

        option :ipv6_addr, short: '-6',
                            desc: 'Extract all IPv6 addresses' do
                              @pattern = IPV6_ADDR
                            end

        option :ip, short: '-I',
                     desc: 'Extract all IP addresses' do
                       @pattern = IP
                     end

        option :host, short: '-H',
                       desc: 'Extract all host names' do
                         @pattern = HOST_NAME
                       end

        option :domain, short: '-D',
                         desc: 'Extract all domain names' do
                           @pattern = DOMAIN
                         end

        option :url, short: '-U',
                      desc: 'Extract all URLs' do
                        @pattern = URL
                      end

        option :user_name, desc: 'Extract all user names' do
          @pattern = USER_NAME
        end

        option :email_addr, short: '-E',
                             desc: 'Extract all email addresses' do
                               @pattern = EMAIL_ADDRESS
                             end

        option :phone_number, desc: 'Extract all phone numbers' do
          @pattern = PHONE_NUMBER
        end

        option :ssn, desc: 'Extract all Social Security Numbers (SSNs)' do
          @pattern = SSN
        end

        option :file_name, desc: 'Extract all file names' do
          @pattern = FILE_NAME
        end

        option :dir_name, desc: 'Extract all directory names' do
          @pattern = DIR_NAME
        end

        option :relative_unix_path, desc: 'Extract all relative UNIX paths' do
          @pattern = RELATIVE_UNIX_PATH
        end

        option :absolute_unix_path, desc: 'Extract all absolute UNIX paths' do
          @pattern = ABSOLUTE_UNIX_PATH
        end

        option :unix_path, desc: 'Extract all UNIX paths' do
          @pattern = UNIX_PATH
        end

        option :relative_windows_path, desc: 'Extract all relative Windows paths' do
          @pattern = RELATIVE_WINDOWS_PATH
        end

        option :absolute_windows_path, desc: 'Extract all absolute Windows paths' do
          @pattern = ABSOLUTE_WINDOWS_PATH
        end

        option :windows_path, desc: 'Extract all Windows paths' do
          @pattern = WINDOWS_PATH
        end

        option :relative_path, desc: 'Extract all relative paths' do
          @pattern = RELATIVE_PATH
        end

        option :absolute_path, desc: 'Extract all absolute paths' do
          @pattern = ABSOLUTE_PATHS
        end

        option :path, short: '-P',
          desc: 'Extract all paths' do
            @pattern = PATH
          end

        option :variable_name, desc: 'Extract all variable names' do
          @pattern = VARIABLE_NAME
        end

        option :function_name, desc: 'Extract all function names' do
          @pattern = FUNCTION_NAMES
        end

        option :md5, desc: 'Extract all MD5 hashes' do
          @pattern = MD5
        end

        option :sha1, desc: 'Extract all SHA1 hashes' do
          @pattern = SHA1
        end

        option :sha256, desc: 'Extract all SHA256 hashes' do
          @pattern = SHA256
        end

        option :sha512, desc: 'Extract all SHA512 hashes' do
          @pattern = SHA512
        end

        option :hash, desc: 'Extract all hashes' do
          @pattern = HASH
        end

        option :ssh_private_key, desc: 'Extract all SSH private key data' do
          @pattern = SSH_PRIVATE_KEY
        end

        option :ssh_public_key, desc: 'Extract all SSH public key data' do
          @pattern = SSH_PUBLIC_KEY
        end

        option :private_key, desc: 'Extract all private key data' do
          @pattern = PRIVATE_KEY
        end

        option :rsa_public_key, desc: 'Extract all RSA public key data' do
          @pattern = RSA_PUBLIC_KEY
        end

        option :dsa_public_key, desc: 'Extract all DSA public key data' do
          @pattern = DSA_PUBLIC_KEY
        end

        option :ec_public_key, desc: 'Extract all EC public key data' do
          @pattern = EC_PUBLIC_KEY
        end

        option :ssh_public_key, desc: 'Extract all SSH public key data' do
          @pattern = SSH_PUBLIC_KEY
        end

        option :public_key, desc: 'Extract all public key data' do
          @pattern = PUBLIC_KEY
        end

        option :single_quoted_string,  desc: 'Extract all single-quoted strings' do
          @pattern = SINGLE_QUOTED_STRING
        end

        option :double_quoted_string,  desc: 'Extract all double-quoted strings' do
          @pattern = DOUBLE_QUOTED_STRING
        end

        option :string, short: '-S',
                         desc: 'Extract all quoted strings' do
                           @pattern = STRING
                         end

        option :base64, short: '-B',
                        desc: 'Extract all Base64 strings' do
                          @pattern = BASE64
                        end

        option :regexp, short: '-e',
                        value: {type: Regexp},
                        desc: 'Custom regular expression to search for' do |regexp|
                          @pattern = regexp
                        end

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

          open_input_stream(*files) do |input|
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
end

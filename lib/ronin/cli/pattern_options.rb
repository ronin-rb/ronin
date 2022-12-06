# frozen_string_literal: true
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

require 'ronin/support/text/patterns'

module Ronin
  class CLI
    #
    # Adds pattern options to a command.
    #
    # ## Options
    #
    #     -N, --number                     Searches for all numbers
    #     -X, --hex-number                 Searches for all hexadecimal numbers
    #     -V, --version-number             Searches for all version numbers
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
    #         --aws-access-key-id          Searches for all AWS access key IDs
    #         --aws-secret-access-key      Searches for all AWS secret access key
    #     -A, --api-key                    Secretes for all API keys
    #         --single-quoted-string       Searches for all single-quoted strings
    #         --double-quoted-string       Searches for all double-quoted strings
    #     -S, --string                     Searches for all quoted strings
    #     -B, --base64                     Searches for all Base64 strings
    #     -e, --regexp /REGEXP/            Custom regular expression to search for
    #
    module PatternOptions
      include Support::Text::Patterns

      #
      # Adds pattern options to the command.
      #
      # @param [Class<Command>] command
      #   The command including {PatternOptions}.
      #
      def self.included(command)
        command.option :number, short: '-N',
                         desc: 'Searches for all numbers' do
                           @pattern = NUMBER
                         end

        command.option :hex_number, short: '-X',
                             desc: 'Searches for all hexadecimal numbers' do
                               @pattern = NUMBER
                             end

        command.option :version_number, short: '-V',
                                        desc: 'Searches for all version numbers' do
                                          @pattern = VERSION_NUMBER
                                        end

        command.option :word, short: '-w',
                       desc: 'Searches for all words' do
                         @pattern = WORD
                       end

        command.option :mac_addr, desc: 'Searches for all MAC addresses' do
          @pattern = MAC_ADDR
        end

        command.option :ipv4_addr, short: '-4',
                            desc: 'Searches for all IPv4 addresses' do
                              @pattern = IPV4_ADDR
                            end

        command.option :ipv6_addr, short: '-6',
                            desc: 'Searches for all IPv6 addresses' do
                              @pattern = IPV6_ADDR
                            end

        command.option :ip, short: '-I',
                     desc: 'Searches for all IP addresses' do
                       @pattern = IP
                     end

        command.option :host, short: '-H',
                       desc: 'Searches for all host names' do
                         @pattern = HOST_NAME
                       end

        command.option :domain, short: '-D',
                         desc: 'Searches for all domain names' do
                           @pattern = DOMAIN
                         end

        command.option :uri, desc: 'Searches for all URIs' do
                               @pattern = URI
                             end

        command.option :url, short: '-U',
                      desc: 'Searches for all URLs' do
                        @pattern = URL
                      end

        command.option :user_name, desc: 'Searches for all user names' do
          @pattern = USER_NAME
        end

        command.option :email_addr, short: '-E',
                             desc: 'Searches for all email addresses' do
                               @pattern = EMAIL_ADDRESS
                             end

        command.option :obfuscated_email_addr, desc: 'Searches for all obfuscated email addresses' do
                               @pattern = OBFUSCATED_EMAIL_ADDRESS
                             end

        command.option :phone_number, desc: 'Searches for all phone numbers' do
          @pattern = PHONE_NUMBER
        end

        command.option :ssn, desc: 'Searches for all Social Security Numbers (SSNs)' do
          @pattern = SSN
        end

        command.option :amex_cc, desc: 'Searches for all AMEX Credit Card numbers' do
          @pattern = AMEX_CC
        end

        command.option :discover_cc, desc: 'Searches for all Discord Card numbers' do
          @pattern = DISCOVER_CC
        end

        command.option :mastercard_cc, desc: 'Searches for all MasterCard numbers' do
          @pattern = MASTERCARD_CC
        end

        command.option :visa_cc, desc: 'Searches for all VISA Credit Card numbers' do
          @pattern = VISA_CC
        end

        command.option :visa_mastercard_cc, desc: 'Searches for all VISA MasterCard numbers' do
          @pattern = VISA_MASTERCARD_CC
        end

        command.option :cc, desc: 'Searches for all Credit Card numbers' do
          @pattern = CC
        end

        command.option :file_name, desc: 'Searches for all file names' do
          @pattern = FILE_NAME
        end

        command.option :dir_name, desc: 'Searches for all directory names' do
          @pattern = DIR_NAME
        end

        command.option :relative_unix_path, desc: 'Searches for all relative UNIX paths' do
          @pattern = RELATIVE_UNIX_PATH
        end

        command.option :absolute_unix_path, desc: 'Searches for all absolute UNIX paths' do
          @pattern = ABSOLUTE_UNIX_PATH
        end

        command.option :unix_path, desc: 'Searches for all UNIX paths' do
          @pattern = UNIX_PATH
        end

        command.option :relative_windows_path, desc: 'Searches for all relative Windows paths' do
          @pattern = RELATIVE_WINDOWS_PATH
        end

        command.option :absolute_windows_path, desc: 'Searches for all absolute Windows paths' do
          @pattern = ABSOLUTE_WINDOWS_PATH
        end

        command.option :windows_path, desc: 'Searches for all Windows paths' do
          @pattern = WINDOWS_PATH
        end

        command.option :relative_path, desc: 'Searches for all relative paths' do
          @pattern = RELATIVE_PATH
        end

        command.option :absolute_path, desc: 'Searches for all absolute paths' do
          @pattern = ABSOLUTE_PATHS
        end

        command.option :path, short: '-P',
                      desc: 'Searches for all paths' do
                        @pattern = PATH
                      end

        command.option :variable_name, desc: 'Searches for all variable names' do
          @pattern = VARIABLE_NAME
        end

        command.option :function_name, desc: 'Searches for all function names' do
          @pattern = FUNCTION_NAME
        end

        command.option :md5, desc: 'Searches for all MD5 hashes' do
          @pattern = MD5
        end

        command.option :sha1, desc: 'Searches for all SHA1 hashes' do
          @pattern = SHA1
        end

        command.option :sha256, desc: 'Searches for all SHA256 hashes' do
          @pattern = SHA256
        end

        command.option :sha512, desc: 'Searches for all SHA512 hashes' do
          @pattern = SHA512
        end

        command.option :hash, desc: 'Searches for all hashes' do
          @pattern = HASH
        end

        command.option :ssh_private_key, desc: 'Searches for all SSH private key data' do
          @pattern = SSH_PRIVATE_KEY
        end

        command.option :ssh_public_key, desc: 'Searches for all SSH public key data' do
          @pattern = SSH_PUBLIC_KEY
        end

        command.option :private_key, short: '-K',
                                     desc: 'Searches for all private key data' do
                                       @pattern = PRIVATE_KEY
                                     end

        command.option :rsa_public_key, desc: 'Searches for all RSA public key data' do
          @pattern = RSA_PUBLIC_KEY
        end

        command.option :dsa_public_key, desc: 'Searches for all DSA public key data' do
          @pattern = DSA_PUBLIC_KEY
        end

        command.option :ec_public_key, desc: 'Searches for all EC public key data' do
          @pattern = EC_PUBLIC_KEY
        end

        command.option :ssh_public_key, desc: 'Searches for all SSH public key data' do
          @pattern = SSH_PUBLIC_KEY
        end

        command.option :public_key, desc: 'Searches for all public key data' do
          @pattern = PUBLIC_KEY
        end

        command.option :aws_access_key_id, desc: 'Searches for all AWS access key IDs' do
          @pattern = AWS_ACCESS_KEY_ID
        end

        command.option :aws_secret_access_key, desc: 'Searches for all AWS secret access key' do
          @pattern = AWS_SECRET_ACCESS_KEY
        end

        command.option :api_key, short: '-A',
                                 desc: 'Secretes for all API keys' do
                                   @pattern = API_KEY
                                 end

        command.option :single_quoted_string,  desc: 'Searches for all single-quoted strings' do
          @pattern = SINGLE_QUOTED_STRING
        end

        command.option :double_quoted_string,  desc: 'Searches for all double-quoted strings' do
          @pattern = DOUBLE_QUOTED_STRING
        end

        command.option :string, short: '-S',
                         desc: 'Searches for all quoted strings' do
                           @pattern = STRING
                         end

        command.option :base64, short: '-B',
                        desc: 'Searches for all Base64 strings' do
                          @pattern = BASE64
                        end

        command.option :regexp, short: '-e',
                        value: {type: Regexp},
                        desc: 'Custom regular expression to search for' do |regexp|
                          @pattern = regexp
                        end
      end
    end
  end
end

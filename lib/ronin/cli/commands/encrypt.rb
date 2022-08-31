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

require 'ronin/cli/command'

require 'ronin/support/crypto/cipher'

module Ronin
  class CLI
    module Commands
      #
      # Encrypts data.
      #
      # ## Usage
      #
      #     ronin encrypt [options] [FILE ...]
      #
      # ## Options
      #
      #     -k, --key STRING                 The key String
      #     -K, --key-file FILE              The key file
      #     -c, --cipher NAME                The cipher to encrypt with. See --list-ciphers (Default: aes-256-cbc)
      #     -P, --password PASSWORD          The password to encrypt with
      #     -H md5|sha1|sha256|sha512,       The hash algorithm to use for the password (Default: sha256)
      #         --hash
      #         --iv STRING                  Sets the Initial Vector (IV) value of the cipher
      #         --padding NUM                Sets the padding of the encryption cipher
      #     -b, --block-size NUM             The size in bytes to read data in (Default: 16384)
      #         --list-ciphers               List all available ciphers
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       The file(s) to encrypt
      #
      class Encrypt < Command

        option :cipher, short: '-c',
                        value: {
                          type:    String,
                          usage:   'NAME',
                          default: 'aes-256-cbc'
                        },
                        desc: 'The cipher to encrypt with. See --list-ciphers'

        option :password, short: '-P',
                          value: {
                            type:  String,
                            usage: 'PASSWORD'
                          },
                          desc: 'The password to encrypt with'

        option :hash, short: '-H',
                      value: {
                        type:    [:md5, :sha1, :sha256, :sha512],
                        default: :sha256
                      },
                      desc: 'The hash algorithm to use for the password'

        option :iv, value: {
                      type:  String,
                      usage: 'STRING'
                    },
                    desc: 'Sets the Initial Vector (IV) value of the cipher'

        option :padding, value: {
                           type:  Integer,
                           usage: 'NUM'
                         },
                         desc: 'Sets the padding of the encryption cipher'

        option :block_size, short: '-b',
                            value: {
                              type:    Integer,
                              usage:   'NUM',
                              default: 16384
                            },
                            desc: 'The size in bytes to read data in'

        option :list_ciphers, desc: 'List the supported ciphers'

        argument :file, required: false,
                        repeats:  true,
                        desc:     'The file(s) to encrypt'

        description 'Encrypts data'

        man_page 'ronin-encrypt.1'

        #
        # Runs the `ronin encrypt` command.
        #
        # @param [Array<String>] files
        #   Optional files to encrypt.
        #
        def run(*files)
          if options[:list_ciphers]
            puts Support::Crypto::Cipher.supported
            return
          end

          unless (options[:key] || options[:key_file] || options[:password])
            print_error "must specify --password, --key, or --key-file"
            exit(1)
          end

          key = if    options[:key]      then options[:key]
                elsif options[:key_file] then File.binread(options[:key_file])
                end

          cipher = Support::Crypto::Cipher.new(
            options[:cipher], direction: :encrypt,
                              key:       key,
                              hash:      options[:hash],
                              password:  options[:password]
          )

          unless files.empty?
            files.each do |path|
              begin
                File.open(path,'rb') do |file|
                  cipher.stream(file, output: stdout)
                end
              rescue Errno::ENOENT
                print_error "no such file or directory: #{path}"
                exit(1)
              end
            end
          else
            cipher.stream(stdin, output: stdout)
          end
        end

      end
    end
  end
end

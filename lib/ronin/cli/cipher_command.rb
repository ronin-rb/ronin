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

require 'ronin/cli/file_processor_command'
require 'ronin/cli/key_options'

require 'ronin/support/crypto/cipher'

module Ronin
  class CLI
    module Commands
      class CipherCommand < FileProcessorCommand

        include KeyOptions

        option :cipher, short: '-c',
                        value: {
                          type:    String,
                          usage:   'NAME',
                          default: 'aes-256-cbc'
                        },
                        desc: 'The cipher to use. See --list-ciphers'

        option :password, short: '-P',
                          value: {
                            type:  String,
                            usage: 'PASSWORD'
                          },
                          desc: 'The password for the cipher'

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
                         desc: 'Sets the padding of the cipher'

        option :block_size, short: '-b',
                            value: {
                              type:    Integer,
                              usage:   'NUM',
                              default: 16384
                            },
                            desc: 'The size in bytes to read data in'

        option :list_ciphers, desc: 'List the supported ciphers'

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

          super(*files)
        end

        #
        # Opens the file in binary mode.
        #
        # @param [Stirng] path
        #   The path to the file to open.
        #
        # @yield [file]
        #   If a block is given, the newly opened file will be yielded.
        #   Once the block returns the file will automatically be closed.
        #
        # @yieldparam [File] file
        #   The newly opened file.
        #
        # @return [File, nil]
        #   If no block is given, the newly opened file object will be returned.
        #   If no block was given, then `nil` will be returned.
        #
        def open_file(path,&block)
          super(path,'rb',&block)
        end

        #
        # Initializes a new cipher.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for
        #   `Ronin::Support::Crypto::Cipher#initialize`.
        #
        # @return [Ronin::Support::Crypto::Cipher]
        #   The new cipher object.
        #
        def cipher(**kwargs)
          Support::Crypto::Cipher.new(
            options[:cipher], key:       @key,
                              hash:      options[:hash],
                              password:  options[:password],
                              **kwargs
          )
        end

        #
        # Decrypts the input stream.
        #
        # @param [IO, StringIO] input
        #   The input stream to decrypt.
        #
        def process_input(input)
          cipher.stream(input, block_size: @block_size, output: stdout)
        end


      end
    end
  end
end

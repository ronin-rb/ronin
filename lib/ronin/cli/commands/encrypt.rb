# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/cli/cipher_command'

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
      class Encrypt < CipherCommand

        description 'Encrypts data'

        man_page 'ronin-encrypt.1'

        #
        # Creates a new encryption cipher.
        #
        # @return [Ronin::Support::Crypto::Cipher]
        #
        def cipher
          super(direction: :encrypt)
        end

      end
    end
  end
end

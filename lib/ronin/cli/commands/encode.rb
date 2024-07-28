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

require_relative '../string_methods_command'

module Ronin
  class CLI
    module Commands
      #
      # Encodes each character of data into a variety of encodings.
      #
      # ## Usage
      #
      #     ronin encode [options] [FILE ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #         --string STRING              Optional string to process
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #         --base16                     Base16 encodes the data
      #         --base32                     Base32 encodes the data
      #     -b, --base64=[strict|url]        Base64 encodes the data
      #     -z, --zlib                       Zlib compresses the data
      #     -g, --gzip                       gzip compresses the data
      #     -c, --c                          Encodes the data as a C string
      #     -X, --hex                        Hex encode the data (ex: "414141...")
      #     -H, --html                       HTML encodes the data
      #     -u, --uri                        URI encodes the data
      #         --http                       HTTP encodes the data
      #     -j, --js                         JavaScript encodes the data
      #     -S, --shell                      Encodes the data as a Shell String
      #     -P, --powershell                 Encodes the data as a PowerShell String
      #         --punycode                   Encodes the data as Punycode
      #     -Q, --quoted-printable           Encodes the data as Quoted Printable
      #     -R, --ruby                       Encodes the data as a Ruby String
      #         --uuencode                   uuencodes the data
      #     -x, --xml                        XML encodes the data
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to process
      #
      class Encode < StringMethodsCommand

        option :base16, desc: 'Base16 encodes the data' do
          require 'ronin/support/encoding/base16'
          @method_calls << :base16_encode
        end

        option :base32, desc: 'Base32 encodes the data' do
          require 'ronin/support/encoding/base32'
          @method_calls << :base32_encode
        end

        option :base64, short: '-b',
                        equals: true,
                        value: {
                          type:     [:strict, :url],
                          required: false
                        },
                        desc: 'Base64 encodes the data' do |mode=nil|
                          require 'ronin/support/encoding/base64'
                          @method_calls << if mode
                                             [:base64_encode, [mode]]
                                           else
                                             :base64_encode
                                           end
                        end

        option :zlib, short: '-z',
                      desc:  'Zlib compresses the data' do
                        require 'ronin/support/compression/core_ext'
                        @method_calls << :zlib_deflate
                      end

        option :gzip, short: '-g',
                      desc:  'gzip compresses the data' do
                        require 'ronin/support/compression/core_ext'
                        @method_calls << :gzip
                      end

        option :c, short: '-c',
                   desc: 'Encodes the data as a C string' do
                     require 'ronin/support/encoding/c'
                     @method_calls << :c_encode
                   end

        option :hex, short: '-X',
                     desc: 'Hex encode the data (ex: "414141...")' do
                       require 'ronin/support/encoding/hex'
                       @method_calls << :hex_encode
                     end

        option :html, short: '-H',
                      desc: 'HTML encodes the data' do
                        require 'ronin/support/encoding/html'
                        @method_calls << :html_encode
                      end

        option :uri, short: '-u',
                     desc: 'URI encodes the data' do
                       require 'ronin/support/encoding/uri'
                       @method_calls << :uri_encode
                     end

        option :http, desc: 'HTTP encodes the data' do
          require 'ronin/support/encoding/http'
          @method_calls << :http_encode
        end

        option :js, short: '-j',
                    desc: 'JavaScript encodes the data' do
                      require 'ronin/support/encoding/js'
                      @method_calls << :js_encode
                    end

        option :shell, short: '-S',
                       desc: 'Encodes the data as a Shell String' do
                         require 'ronin/support/encoding/shell'
                         @method_calls << :shell_encode
                       end

        option :powershell, short: '-P',
                            desc: 'Encodes the data as a PowerShell String' do
                              require 'ronin/support/encoding/powershell'
                              @method_calls << :powershell_encode
                            end

        option :punycode, desc: 'Encodes the data as Punycode' do
          require 'ronin/support/encoding/punycode'
          @method_calls << :punycode_encode
        end

        option :quoted_printable, short: '-Q',
                                  desc: 'Encodes the data as Quoted Printable' do
                                    require 'ronin/support/encoding/quoted_printable'
                                    @method_calls << :quoted_printable_encode
                                  end

        option :ruby, short: '-R',
                      desc: 'Encodes the data as a Ruby String' do
                        require 'ronin/support/encoding/ruby'
                        @method_calls << :ruby_encode
                      end

        option :uuencode, desc: 'uuencodes the data' do
          require 'ronin/support/encoding/uuencoding'
          @method_calls << :uuencode
        end

        option :xml, short: '-x',
                     desc: 'XML encodes the data' do
                       require 'ronin/support/encoding/xml'
                       @method_calls << :xml_encode
                     end

        description 'Encodes each character of data into a variety of encodings'

        man_page 'ronin-encode.1'

      end
    end
  end
end

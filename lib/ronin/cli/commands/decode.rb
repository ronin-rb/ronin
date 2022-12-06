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

require 'ronin/cli/string_methods_command'

module Ronin
  class CLI
    module Commands
      #
      # Decode each character of data from a variety of encodings.
      #
      # ## Usage
      #
      #     ronin decode [options] [FILE ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #         --string STRING              Optional string to process
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #         --base32                     Base32 decodes the data
      #     -b, --base64=[strict|url]        Base64 decodes the data
      #     -c, --c                          Encodes the data as a C string
      #     -X, --hex                        Hex decode the data (ex: "414141...")
      #     -H, --html                       HTML decodes the data
      #     -u, --uri                        URI decodes the data
      #         --http                       HTTP decodes the data
      #     -j, --js                         JavaScript decodes the data
      #     -S, --shell                      Encodes the data as a Shell String
      #     -P, --powershell                 Encodes the data as a PowerShell String
      #     -R, --ruby                       Ruby decodes the data
      #     -x, --xml                        XML decodes the data
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to process
      #
      class Decode < StringMethodsCommand

        option :base32, desc: 'Base32 decodes the data' do
                          require 'ronin/support/encoding/base32'
                          @method_calls << :base32_decode
                        end

        option :base64, short: '-b',
                        equals: true,
                        value: {
                          type:     [:strict, :url],
                          required: false
                        },
                        desc: 'Base64 decodes the data' do |mode=nil|
                          require 'ronin/support/encoding/base64'
                          if mode
                            @method_calls << [:base64_decode, [mode]]
                          else
                            @method_calls << :base64_decode
                          end
                        end

        option :c, short: '-c',
                   desc: 'Decodes the data as a C string' do
                     require 'ronin/support/encoding/c'
                     @method_calls << :c_decode
                   end

        option :hex, short: '-X',
                     desc: 'Hex decode the data (ex: "414141...")' do
                       require 'ronin/support/encoding/hex'
                       @method_calls << :hex_decode
                     end

        option :html, short: '-H',
                      desc: 'HTML decodes the data' do
                        require 'ronin/support/encoding/html'
                        @method_calls << :html_decode
                      end

        option :uri, short: '-u',
                     desc: 'URI decodes the data' do
                       require 'ronin/support/encoding/uri'
                       @method_calls << :uri_decode
                     end

        option :http, desc: 'HTTP decodes the data' do
                        require 'ronin/support/encoding/http'
                        @method_calls << :http_decode
                      end

        option :js, short: '-j',
                    desc: 'JavaScript decodes the data' do
                      require 'ronin/support/encoding/js'
                      @method_calls << :js_decode
                    end

        option :shell, short: '-S',
                       desc: 'Decodes the data as a Shell String' do
                         require 'ronin/support/encoding/shell'
                         @method_calls << :shell_decode
                       end

        option :powershell, short: '-P',
                            desc: 'Decodes the data as a PowerShell String' do
                              require 'ronin/support/encoding/powershell'
                              @method_calls << :powershell_decode
                            end

        option :ruby, short: '-R',
                      desc: 'Ruby decodes the data' do
                        require 'ronin/support/encoding/ruby'
                        @method_calls << :ruby_decode
                      end

        option :xml, short: '-x',
                     desc: 'XML decodes the data' do
                       require 'ronin/support/encoding/xml'
                       @method_calls << :xml_decode
                     end

        description 'Decodes each character of data from a variety of encodings'

      end
    end
  end
end

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

require 'ronin/cli/string_command'
require 'ronin/support/format'

module Ronin
  class CLI
    module Commands
      #
      # Encodes each character of data into a variety of formats.
      #
      # ## Usage
      #
      #     ronin encode [options] {-i FILE | STRING ...}
      #
      # ## Options
      #
      #     -i, --input FILE                 Optional input file
      #     -o, --output FILE                Optional output file
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #         --base32                     Base32 encodes the data
      #     -b, --base64=[strict|url]        Base64 encodes the data
      #     -c, --c                          Encodes the data as a C string
      #     -X, --hex                        Hex encode the data (ex: "414141...")
      #     -H, --html                       HTML encodes the data
      #     -u, --uri                        URI encodes the data
      #         --http                       HTTP encodes the data
      #     -j, --js                         JavaScript encodes the data
      #     -S, --shell                      Encodes the data as a Shell String
      #     -P, --powershell                 Encodes the data as a PowerShell String
      #     -x, --xml                        XML encodes the data
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [STRING ...]                     Optional string value(s) to process
      #
      class Encode < StringCommand

        option :base32, desc: 'Base32 encodes the data' do
                          require 'ronin/support/format/base32'
                          @method_calls << :base32_encode
                        end

        option :base64, short: '-b',
                        equals: true,
                        value: {
                          type:     [:strict, :url],
                          required: false
                        },
                        desc: 'Base64 encodes the data' do |mode=nil|
                          require 'ronin/support/format/base64'
                          if mode
                            @method_calls << [:base64_encode, [mode]]
                          else
                            @method_calls << :base64_encode
                          end
                        end

        option :c, short: '-c',
                   desc: 'Encodes the data as a C string' do
                     require 'ronin/support/format/c'
                     @method_calls << :c_encode
                   end

        option :hex, short: '-X',
                     desc: 'Hex encode the data (ex: "414141...")' do
                       require 'ronin/support/format/hex'
                       @method_calls << :hex_encode
                     end

        option :html, short: '-H',
                      desc: 'HTML encodes the data' do
                        require 'ronin/support/format/html'
                        @method_calls << :html_encode
                      end

        option :uri, short: '-u',
                     desc: 'URI encodes the data' do
                       require 'ronin/support/format/uri'
                       @method_calls << :uri_encode
                     end

        option :http, desc: 'HTTP encodes the data' do
                        require 'ronin/support/format/http'
                        @method_calls << :http_encode
                      end

        option :js, short: '-j',
                    desc: 'JavaScript encodes the data' do
                      require 'ronin/support/format/js'
                      @method_calls << :js_encode
                    end

        option :shell, short: '-S',
                       desc: 'Encodes the data as a Shell String' do
                         require 'ronin/support/format/shell'
                         @method << :shell_encode
                       end

        option :powershell, short: '-P',
                            desc: 'Encodes the data as a PowerShell String' do
                              require 'ronin/support/format/powershell'
                              @method << :powershell_encode
                            end

        option :xml, short: '-x',
                     desc: 'XML encodes the data' do
                       require 'ronin/support/format/xml'
                       @method_calls << :xml_encode
                     end

        description 'Encodes each character of data into a variety of formats'

      end
    end
  end
end

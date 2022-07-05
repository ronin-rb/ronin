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
      # Escapes each special character for a  variety of formats.
      #
      # ## Usage
      #
      #     ronin escape [options] [STRING ... | -i FILE]
      #
      # ## Options
      #
      #     -i, --input FILE                 Optional input file
      #     -o, --output FILE                Optional output file
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -c, --c                          Escapes the data as a C string
      #     -X, --hex                        Escapes the data as a hex string (ex: ABC\x01\x02\x03...)
      #     -H, --html                       HTML escapes the data
      #     -u, --uri                        URI escapes the data
      #         --http                       HTTP escapes the data
      #     -j, --js                         JavaScript escapes the data
      #     -S, --shell                      Escapes the data as a Shell String
      #     -P, --powershell                 Escapes the data as a PowerShell String
      #     -x, --xml                        XML escapes the data
      #     -s, --string                     Escapes the data as a Ruby String
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [STRING ...]                     Optional string value(s) to process
      #
      class Escape < StringCommand

        option :c, short: '-c',
                   desc: 'Escapes the data as a C string' do
                     require 'ronin/support/format/c'
                     @method_calls << :c_escape
                   end

        option :hex, short: '-X',
                     desc: 'Escapes the data as a hex string (ex: "ABC\x01\x02\x03...")' do
                       require 'ronin/support/format/hex'
                       @method_calls << :hex_escape
                     end

        option :html, short: '-H',
                      desc: 'HTML escapes the data' do
                        require 'ronin/support/format/html'
                        @method_calls << :html_escape
                      end

        option :uri, short: '-u',
                     desc: 'URI escapes the data' do
                       require 'ronin/support/format/uri'
                       @method_calls << :uri_escape
                     end

        option :http, desc: 'HTTP escapes the data' do
          require 'ronin/support/format/http'
          @method_calls << :http_escape
        end

        option :js, short: '-j',
                    desc: 'JavaScript escapes the data' do
                      require 'ronin/support/format/js'
                      @method_calls << :js_escape
                    end

        option :shell, short: '-S',
                       desc: 'Escapes the data as a Shell String' do
                         require 'ronin/support/format/shell'
                         @method_calls << :shell_escapes
                       end

        option :powershell, short: '-P',
                            desc: 'Escapes the data as a PowerShell String' do
                              require 'ronin/support/format/powershell'
                              @method_calls << :powershell_escapes
                            end

        option :xml, short: '-x',
                     desc: 'XML escapes the data' do
                       require 'ronin/support/format/xml'
                       @method_calls << :xml_escape
                     end

        option :string, short: '-s',
                        desc: 'Escapes the data as a Ruby String' do
                          require 'ronin/support/format/text'
                          @method_calls << :escape
                        end

        description 'Escapes each special character for a variety of formats'

      end
    end
  end
end

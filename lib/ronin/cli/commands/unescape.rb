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
      # Unescapes each escaped character from a variety of encodings.
      #
      # ## Usage
      #
      #     ronin unescape [options] [FILE ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #         --string STRING              Optional string to process
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -c, --c                          Unescapes the data as a C string
      #     -X, --hex                        Unescape the data as a hex string (ex: ABC\x01\x02\x03...)
      #     -H, --html                       HTML unescapes the data
      #     -u, --uri                        URI unescapes the data
      #         --http                       HTTP unescapes the data
      #     -j, --js                         JavaScript unescapes the data
      #     -S, --shell                      Unescapes the data as a Shell String
      #     -P, --powershell                 Unescapes the data as a PowerShell String
      #     -R, --ruby                       Unescapes the data as a Ruby String
      #     -x, --xml                        XML unescapes the data
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to process
      #
      class Unescape < StringMethodsCommand

        option :c, short: '-c',
                   desc: 'Unescapes the data as a C string' do
                     require 'ronin/support/encoding/c'
                     @method_calls << :c_unescape
                   end

        option :hex, short: '-X',
                     desc: 'Unescape the data as a hex string (ex: ABC\x01\x02\x03...)' do
                       require 'ronin/support/encoding/hex'
                       @method_calls << :hex_unescape
                     end

        option :html, short: '-H',
                      desc: 'HTML unescapes the data' do
                        require 'ronin/support/encoding/html'
                        @method_calls << :html_unescape
                      end

        option :uri, short: '-u',
                     desc: 'URI unescapes the data' do
                       require 'ronin/support/encoding/uri'
                       @method_calls << :uri_unescape
                     end

        option :http, desc: 'HTTP unescapes the data' do
          require 'ronin/support/encoding/http'
          @method_calls << :http_unescape
        end

        option :js, short: '-j',
                    desc: 'JavaScript unescapes the data' do
                      require 'ronin/support/encoding/js'
                      @method_calls << :js_unescape
                    end

        option :shell, short: '-S',
                       desc: 'Unescapes the data as a Shell String' do
                         require 'ronin/support/encoding/shell'
                         @method_calls << :shell_unescape
                       end

        option :powershell, short: '-P',
                            desc: 'Unescapes the data as a PowerShell String' do
                              require 'ronin/support/encoding/powershell'
                              @method_calls << :powershell_unescape
                            end

        option :ruby, short: '-R',
                      desc: 'Unescapes the data as a Ruby String' do
                        require 'ronin/support/encoding/ruby'
                        @method_calls << :ruby_unescape
                      end

        option :xml, short: '-x',
                     desc: 'XML unescapes the data' do
                       require 'ronin/support/encoding/xml'
                       @method_calls << :xml_unescape
                     end

        description 'Unescapes each escaped character from a variety of encodings'

      end
    end
  end
end

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
      # Escapes each special character for a variety of encodings.
      #
      # ## Usage
      #
      #     ronin escape [options] [FILE ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #     -s, --string STRING              Optional string to process
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -c, --c                          Escapes the data as a C string
      #     -X, --hex                        Escapes the data as a hex string (ex: ABC\x01\x02\x03...)
      #     -H, --html                       HTML escapes the data
      #     -u, --uri                        URI escapes the data
      #         --http                       HTTP escapes the data
      #     -j, --js                         Encodes the data as a JavaScript string
      #     -n, --nodejs                     Escapes the data as a Node.js string
      #     -S, --shell                      Escapes the data as a Shell string
      #     -P, --powershell                 Escapes the data as a PowerShell string
      #     -Q, --quoted-printable           Escapes the data as Quoted Printable
      #         --perl                       Escapes the data as a Perl string
      #     -p, --php                        Escapes the data as a PHP string
      #         --python                     Escapes the data as a Python string
      #     -R, --ruby                       Escapes the data as a Ruby string
      #     -x, --xml                        XML escapes the data
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to process
      #
      class Escape < StringMethodsCommand

        option :c, short: '-c',
                   desc: 'Escapes the data as a C string' do
                     require 'ronin/support/encoding/c'
                     @method_calls << :c_escape
                   end

        option :hex, short: '-X',
                     desc: 'Escapes the data as a hex string (ex: "ABC\x01\x02\x03...")' do
                       require 'ronin/support/encoding/hex'
                       @method_calls << :hex_escape
                     end

        option :html, short: '-H',
                      desc: 'HTML escapes the data' do
                        require 'ronin/support/encoding/html'
                        @method_calls << :html_escape
                      end

        option :uri, short: '-u',
                     desc: 'URI escapes the data' do
                       require 'ronin/support/encoding/uri'
                       @method_calls << :uri_escape
                     end

        option :http, desc: 'HTTP escapes the data' do
          require 'ronin/support/encoding/http'
          @method_calls << :http_escape
        end

        option :js, short: '-j',
                    desc: 'Encodes the data as a JavaScript string' do
                      require 'ronin/support/encoding/js'
                      @method_calls << :js_escape
                    end

        option :nodejs, short: '-n',
                        desc: 'Escapes the data as a Node.js string' do
                          require 'ronin/support/encoding/node_js'
                          @method_calls << :node_js_escape
                        end

        option :shell, short: '-S',
                       desc: 'Escapes the data as a Shell string' do
                         require 'ronin/support/encoding/shell'
                         @method_calls << :shell_escape
                       end

        option :powershell, short: '-P',
                            desc: 'Escapes the data as a PowerShell string' do
                              require 'ronin/support/encoding/powershell'
                              @method_calls << :powershell_escape
                            end

        option :quoted_printable, short: '-Q',
                                  desc: 'Escapes the data as Quoted Printable' do
                                    require 'ronin/support/encoding/quoted_printable'
                                    @method_calls << :quoted_printable_escape
                                  end

        option :perl, desc: 'Escapes the data as a Perl string' do
                        require 'ronin/support/encoding/perl'
                        @method_calls << :perl_escape
                      end

        option :php, short: '-p',
                     desc: 'Escapes the data as a PHP string' do
                       require 'ronin/support/encoding/php'
                       @method_calls << :php_escape
                     end

        option :python, desc: 'Escapes the data as a Python string' do
                          require 'ronin/support/encoding/python'
                          @method_calls << :python_escape
                        end

        option :ruby, short: '-R',
                      desc: 'Escapes the data as a Ruby string' do
                        require 'ronin/support/encoding/ruby'
                        @method_calls << :ruby_escape
                      end

        option :xml, short: '-x',
                     desc: 'XML escapes the data' do
                       require 'ronin/support/encoding/xml'
                       @method_calls << :xml_escape
                     end

        description 'Escapes each special character for a variety of encodings'

        man_page 'ronin-escape.1'

      end
    end
  end
end

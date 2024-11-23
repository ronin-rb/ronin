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
      # Unescapes each escaped character from a variety of encodings.
      #
      # ## Usage
      #
      #     ronin unescape [options] [FILE ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #     -s, --string STRING              Optional string to process
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -c, --c                          Unescapes the data as a C string
      #     -X, --hex                        Unescape the data as a hex string (ex: ABC\x01\x02\x03...)
      #     -H, --html                       HTML unescapes the data
      #     -u, --uri                        URI unescapes the data
      #         --http                       HTTP unescapes the data
      #     -J, --java                       Unescapes the data as a Java string
      #     -j, --js                         Unescapes the data as a JavaScript string
      #     -n, --nodejs                     Unescapes the data as a Node.js string
      #     -S, --shell                      Unescapes the data as a Shell string
      #     -P, --powershell                 Unescapes the data as a PowerShell string
      #         --perl                       Unescapes the data as a Perl string
      #     -p, --php                        Unescapes the data as a PHP string
      #         --python                     Unescapes the data as a Python string
      #     -R, --ruby                       Unescapes the data as a Ruby string
      #     -Q, --quoted-printable           Unescapes the data as Quoted Printable
      #         --smtp                       Alias for --quoted-printable
      #         --sql                        Unescapes the data as a SQL string
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

        option :java, short: '-J',
                      desc: 'Unescapes the data as a Java string' do
                        require 'ronin/support/encoding/java'
                        @method_calls << :java_unescape
                      end

        option :js, short: '-j',
                    desc: 'Unescapes the data as a JavaScript string' do
                      require 'ronin/support/encoding/js'
                      @method_calls << :js_unescape
                    end

        option :nodejs, short: '-n',
                        desc: 'Unescapes the data as a Node.js string' do
                          require 'ronin/support/encoding/node_js'
                          @method_calls << :node_js_unescape
                        end

        option :shell, short: '-S',
                       desc: 'Unescapes the data as a Shell string' do
                         require 'ronin/support/encoding/shell'
                         @method_calls << :shell_unescape
                       end

        option :powershell, short: '-P',
                            desc: 'Unescapes the data as a PowerShell string' do
                              require 'ronin/support/encoding/powershell'
                              @method_calls << :powershell_unescape
                            end

        option :quoted_printable, short: '-Q',
                                  desc: 'Unescapes the data as Quoted Printable' do
                                    require 'ronin/support/encoding/quoted_printable'
                                    @method_calls << :quoted_printable_unescape
                                  end

        option :smtp, desc: 'Alias for --quoted-printable' do
          require 'ronin/support/encoding/smtp'
          @method_calls << :smtp_unescape
        end

        option :perl, desc: 'Unescapes the data as a Perl String' do
                        require 'ronin/support/encoding/perl'
                        @method_calls << :perl_unescape
                      end

        option :php, short: '-p',
                     desc: 'Unescapes the data as a PHP string' do
                       require 'ronin/support/encoding/php'
                       @method_calls << :php_unescape
                     end

        option :python, desc: 'Unescapes the data as a Python string' do
                          require 'ronin/support/encoding/python'
                          @method_calls << :python_unescape
                        end

        option :ruby, short: '-R',
                      desc: 'Unescapes the data as a Ruby string' do
                        require 'ronin/support/encoding/ruby'
                        @method_calls << :ruby_unescape
                      end

        option :sql, desc: 'Unescapes the data as a SQL string' do
          require 'ronin/support/encoding/sql'
          @method_calls << :sql_unescape
        end

        option :xml, short: '-x',
                     desc: 'XML unescapes the data' do
                       require 'ronin/support/encoding/xml'
                       @method_calls << :xml_unescape
                     end

        description 'Unescapes each escaped character from a variety of encodings'

        man_page 'ronin-unescape.1'

      end
    end
  end
end

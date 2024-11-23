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
      # Unquotes a double/single quoted string.
      #
      # ## Usage
      #
      #     ronin unquote [options] [FILE ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #         --string STRING              Optional string to process
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -X, --hex                        Unquotes the Hex string
      #     -c, --c                          Unquotes the C string
      #     -J, --java                       Unquotes the Java string
      #     -j, --js                         Unquotes the JavaScript string
      #     -n, --nodejs                     Unquotes the Node.js string
      #     -S, --shell                      Unquotes the Shell string
      #     -P, --powershell                 Unquotes the PowerShell string
      #         --perl                       Unquotes the Perl string
      #     -p, --php                        Unquotes the PHP string
      #         --python                     Unquotes the Python string
      #     -R, --ruby                       Unquotes the Ruby string
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to process
      #
      class Unquote < StringMethodsCommand

        option :hex, short: '-X',
                     desc: 'Unquotes the Hex string' do
                       require 'ronin/support/encoding/hex'
                       @method_calls << :hex_unquote
                     end

        option :c, short: '-c',
                   desc: 'Unquotes the C string' do
                     require 'ronin/support/encoding/c'
                     @method_calls << :c_unquote
                   end

        option :java, short: '-J',
                      desc: 'Unquotes the Java string' do
                        require 'ronin/support/encoding/java'
                        @method_calls << :java_unquote
                      end

        option :js, short: '-j',
                    desc: 'Unquotes the JavaScript string' do
                      require 'ronin/support/encoding/js'
                      @method_calls << :js_unquote
                    end

        option :nodejs, short: '-n',
                        desc: 'Unquotes the Node.js string' do
                          require 'ronin/support/encoding/node_js'
                          @method_calls << :node_js_unquote
                        end

        option :shell, short: '-S',
                       desc: 'Unquotes the Shell string' do
                         require 'ronin/support/encoding/shell'
                         @method_calls << :shell_unquote
                       end

        option :powershell, short: '-P',
                            desc: 'Unquotes the PowerShell string' do
                              require 'ronin/support/encoding/powershell'
                              @method_calls << :powershell_unquote
                            end

        option :perl, desc: 'Unquotes the Perl string' do
                        require 'ronin/support/encoding/perl'
                        @method_calls << :perl_unquote
                      end

        option :php, short: '-p',
                     desc: 'Unquotes the PHP string' do
                       require 'ronin/support/encoding/php'
                       @method_calls << :php_unquote
                     end

        option :python, desc: 'Unquotes the Python string' do
                          require 'ronin/support/encoding/python'
                          @method_calls << :python_unquote
                        end

        option :ruby, short: '-R',
                      desc: 'Unquotes the Ruby string' do
                        require 'ronin/support/encoding/ruby'
                        @method_calls << :ruby_unquote
                      end

        description 'Unquotes a double/single quoted string'

        man_page 'ronin-unquote.1'

        #
        # Unquotes the String.
        #
        # @param [String] string
        #   The String to unquote.
        #
        # @return [String]
        #   The unquoted String.
        #
        # @note
        #   If no options are given, then `--string` is assumed.
        #
        def process_string(string)
          if @method_calls.empty?
            string.unquote
          else
            super(string)
          end
        end

      end
    end
  end
end

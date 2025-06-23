# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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
      # Produces quoted a string for a variety of programming languages.
      #
      # ## Usage
      #
      #     ronin quote [options] [FILE ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to process
      #     -s, --string STRING              Optional string to process
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -X, --hex                        Quotes the data as a Hex string
      #     -c, --c                          Quotes the data as a C string
      #     -j, --js                         Quotes the data as a JavaScript string
      #     -S, --shell                      Quotes the data as a Shell string
      #     -P, --powershell                 Quotes the data as a PowerShell string
      #         --python                     Quotes the data as a Python string
      #     -R, --ruby                       Quotes the data as a Ruby string
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to process
      #
      class Quote < StringMethodsCommand

        option :hex, short: '-X',
                     desc: 'Quotes the data as a Hex string' do
                       require 'ronin/support/encoding/hex'
                       @method_calls << :hex_string
                     end

        option :c, short: '-c',
                   desc: 'Quotes the data as a C string' do
                     require 'ronin/support/encoding/c'
                     @method_calls << :c_string
                   end

        option :js, short: '-j',
                    desc: 'Quotes the data as a JavaScript string' do
                      require 'ronin/support/encoding/js'
                      @method_calls << :js_string
                    end

        option :shell, short: '-S',
                       desc: 'Quotes the data as a Shell string' do
                         require 'ronin/support/encoding/shell'
                         @method_calls << :shell_string
                       end

        option :powershell, short: '-P',
                            desc: 'Quotes the data as a PowerShell string' do
                              require 'ronin/support/encoding/powershell'
                              @method_calls << :powershell_string
                            end

        option :python, desc: 'Quotes the data as a Python string' do
                          require 'ronin/support/encoding/python'
                          @method_calls << :python_string
                        end

        option :ruby, short: '-R',
                      desc: 'Quotes the data as a Ruby string' do
                        require 'ronin/support/encoding/ruby'
                        @method_calls << :ruby_string
                      end

        description 'Produces quoted a string for a variety of programming languages'

        man_page 'ronin-quote.1'

        #
        # Quotes the String.
        #
        # @param [String] string
        #   The String to quote.
        #
        # @return [String]
        #   The quoted String.
        #
        # @note
        #   If no options are given, then `--string` is assumed.
        #
        def process_string(string)
          if @method_calls.empty?
            string.inspect
          else
            super(string)
          end
        end

      end
    end
  end
end

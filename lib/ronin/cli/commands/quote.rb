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

require 'ronin/cli/string_methods_command'
require 'ronin/support/format'

module Ronin
  class CLI
    module Commands
      #
      # Produces quoted a string for a variety of programming languages.
      #
      # ## Usage
      #
      #     ronin quote [options] [STRING ... | -i FILE]
      #
      # ## Options
      #
      #     -i, --input FILE                 Optional input file
      #     -o, --output FILE                Optional output file
      #     -M, --multiline                  Process each line separately
      #     -n, --keep-newlines              Preserves newlines at the end of each line
      #     -c, --c                          Quotes the data as a C string
      #     -j, --js                         JavaScript quotes the data
      #     -S, --shell                      Quotes the data as a Shell String
      #     -P, --powershell                 Quotes the data as a PowerShell String
      #     -s, --string                     Quotes the data as a Ruby String
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [STRING ...]                     Optional string value(s) to process
      #
      class Quote < StringMethodsCommand

        option :c, short: '-c',
                   desc: 'Quotes the data as a C string' do
                     require 'ronin/support/format/c'
                     @method_calls << :c_string
                   end

        option :js, short: '-j',
                    desc: 'JavaScript quotes the data' do
                      require 'ronin/support/format/js'
                      @method_calls << :js_string
                    end

        option :shell, short: '-S',
                       desc: 'Quotes the data as a Shell String' do
                         require 'ronin/support/format/shell'
                         @method_calls << :shell_string
                       end

        option :powershell, short: '-P',
                            desc: 'Quotes the data as a PowerShell String' do
                              require 'ronin/support/format/powershell'
                              @method_calls << :powershell_string
                            end

        option :string, short: '-s',
                        desc: 'Quotes the data as a Ruby String' do
                          require 'ronin/support/format/text'
                          @method_calls << :inspect
                        end

        description 'Produces quoted a string for a variety of programming languages'

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

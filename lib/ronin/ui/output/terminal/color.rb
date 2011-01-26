#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
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
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

module Ronin
  module UI
    module Output
      module Terminal
        #
        # The handler for color output to the terminal.
        #
        class Color

          # ANSI Green code
          GREEN = "\e[32m"

          # ANSI Cyan code
          CYAN = "\e[36m"

          # ANSI Yellow code
          YELLOW = "\e[33m"

          # ANSI Red code
          RED = "\e[31m"

          # ANSI Clear code
          CLEAR = "\e[0m"

          #
          # Writes data to `STDOUT`.
          #
          # @param [String] data
          #   The data to write.
          #
          # @since 1.0.0
          #
          def self.write(data)
            STDOUT.write(data)
          end

          #
          # Prints an `info` message.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          def self.print_info(message)
            puts "#{GREEN}[-] #{message}#{CLEAR}"
          end

          #
          # Prints a `debug` message.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          def self.print_debug(message)
            puts "#{CYAN}[=] #{message}#{CLEAR}"
          end

          #
          # Prints a `warning` message.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          def self.print_warning(message)
            puts "#{YELLOW}[*] #{message}#{CLEAR}"
          end

          #
          # Prints an `error` message.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          def self.print_error(message)
            puts "#{RED}[!] #{message}#{CLEAR}"
          end

        end
      end
    end
  end
end

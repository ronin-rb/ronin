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
        # The handler for raw output to the terminal.
        #
        class Raw

          #
          # Writes data to `STDOUT`.
          #
          # @param [String] data
          #   The data to write.
          #
          # @since 1.0.0
          #
          # @api private
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
          # @api private
          #
          def self.print_info(message)
            puts "[-] #{message}"
          end

          #
          # Prints a `debug` message.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          # @api private
          #
          def self.print_debug(message)
            puts "[=] #{message}"
          end

          #
          # Prints a `warning` message.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          # @api private
          #
          def self.print_warning(message)
            puts "[*] #{message}"
          end

          #
          # Prints an `error` messages.
          #
          # @param [String] message
          #   The message to print.
          #
          # @since 1.0.0
          #
          # @api private
          #
          def self.print_error(message)
            puts "[!] #{message}"
          end

        end
      end
    end
  end
end

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

require 'ronin/ui/output/output'

module Ronin
  module UI
    module Output
      module Helpers
        #
        # Writes data unless output has been silenced.
        #
        # @param [String, Object] data
        #   The data to write.
        #
        # @return [Integer, nil]
        #   The number of bytes written.
        #
        # @since 1.0.0
        #
        def write(data)
          unless Output.silent?
            data = data.to_s

            Output.handler.write(data)
            return data.length
          end
        end

        #
        # Prints a character.
        #
        # @param [String, Integer] data
        #   The character or byte to print.
        #
        # @return [String, Integer]
        #   The byte or character.
        #
        # @since 1.0.0
        #
        def putc(data)
          char = data.chr if data.kind_of?(Integer)

          write(data)
          return data
        end

        #
        # Prints one or more messages.
        #
        # @param [Array] messages
        #   The messages to print.
        #
        # @example
        #   puts 'some data'
        #
        # @since 0.3.0
        #
        def puts(*messages)
          unless messages.empty?
            messages.each { |message| write("#{message}#{$/}") }
          else
            write($/)
          end

          return nil
        end

        #
        # Prints formatted data.
        #
        # @param [String] format
        #   The format string.
        #
        # @param [Array] data
        #   The data to format.
        #
        # @return [nil]
        # 
        # @since 1.0.0
        #
        def printf(format,*data)
          write(format % data)
          return nil
        end

        #
        # Prints an `info` message.
        #
        # @param [Array] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_info "Connecting ..."
        #
        # @example Print a formatted message.
        #   print_info "Connected to %s", host
        #
        # @since 0.3.0
        #
        def print_info(*message)
          unless Output.silent?
            Output.handler.print_info(format_message(message))
            return true
          end

          return false
        end

        #
        # Prints a `debug` message.
        #
        # @param [Array, String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example Print a formatted message.
        #   print_debug "vars: %p %p", vars[0], vars[1]
        #
        # @since 0.3.0
        #
        def print_debug(*message)
          if (Output.verbose? && !(Output.silent?))
            Output.handler.print_debug(format_message(message))
            return true
          end

          return false
        end

        #
        # Prints a `warning` message.
        #
        # @param [Array, String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_warning "Detecting a restricted character in the buffer"
        #
        # @example Print a formatted message.
        #   print_warning "Malformed input detected: %p", user_input
        #
        # @since 0.3.0
        #
        def print_warning(*message)
          if (Output.verbose? && !(Output.silent?))
            Output.handler.print_warning(format_message(message))
            return true
          end
          
          return false
        end

        #
        # Prints an `error` message.
        #
        # @param [Array, String] message
        #   The message to print.
        #
        # @return [Boolean]
        #   Specifies whether the messages were successfully printed.
        #
        # @example
        #   print_error "Could not connect!"
        #
        # @example Print a formatted message.
        #   print_error "%p: %s", error.class, error.message
        #
        # @since 0.3.0
        #
        def print_error(*message)
          unless Output.silent?
            Output.handler.print_error(format_message(message))
            return true
          end

          return false
        end

        protected

        #
        # Formats a message to be printed.
        #
        # @param [Array] message
        #   The message and additional Objects to format.
        #
        # @return [String]
        #   The formatted message.
        #
        # @since 1.0.0
        #
        def format_message(message)
          if message.length == 1
            message[0]
          else
            message[0] % message[1..-1]
          end
        end
      end
    end
  end
end

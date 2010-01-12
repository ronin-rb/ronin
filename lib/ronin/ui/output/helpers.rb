#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ronin/ui/output/output'

module Ronin
  module UI
    module Output
      module Helpers
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
          Output.handler.puts(*messages) unless Output.silent?
        end

        #
        # Prints one or more messages as +info+ output.
        #
        # @param [Array] messages
        #   The messages to print.
        #
        # @example
        #   print_info 'Connecting ...'
        #
        # @since 0.3.0
        #
        def print_info(*messages)
          Output.handler.print_info(*messages) unless Output.silent?
        end

        #
        # Prints one or more messages as +debug+ output.
        #
        # @param [Array] messages
        #   The messages to print.
        #
        # @example
        #   print_debug "var1: #{var1.inspect}"
        #
        # @since 0.3.0
        #
        def print_debug(*messages)
          if (Output.verbose? && !(Output.silent?))
            Output.handler.print_debug(*messages)
          end
        end

        #
        # Prints one or more messages as +warning+ output.
        #
        # @param [Array] messages
        #   The messages to print.
        #
        # @example
        #   print_warning 'Detecting a restricted character in the buffer'
        #
        # @since 0.3.0
        #
        def print_warning(*messages)
          if (Output.verbose? && !(Output.silent?))
            Output.handler.print_warning(*messages)
          end
        end

        #
        # Prints one or more messages as +error+ output.
        #
        # @param [Array] messages
        #   The messages to print.
        #
        # @example
        #   print_error 'Could not connect!'
        #
        # @since 0.3.0
        #
        def print_error(*messages)
          Output.handler.print_error(*messages) unless Output.silent?
        end
      end
    end
  end
end

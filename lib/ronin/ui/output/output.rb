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

require 'ronin/ui/output/handler'

module Ronin
  module UI
    module Output
      #
      # @return [Boolean]
      #   Specifies whether verbose output is enabled.
      #
      # @since 0.3.0
      #
      def Output.verbose?
        (@@ronin_verbose ||= :quiet) == :verbose
      end

      #
      # @return [Boolean]
      #   Specifies whether quiet output is enabled.
      #
      # @since 0.3.0
      #
      def Output.quiet?
        (@@ronin_verbose ||= :quiet) == :quiet
      end

      #
      # @return [Boolean]
      #   Specifies whether silent output is enabled.
      #
      # @since 0.3.0
      #
      def Output.silent?
        (@@ronin_verbose ||= :quiet) == :silent
      end

      #
      # Changes the verbose mode.
      #
      # @param [Boolean] mode
      #   The new verbose mode.
      #
      # @return [Boolean]
      #   The new verbose mode.
      #
      # @since 0.3.0
      #
      def Output.verbose=(mode)
        if mode
          @@ronin_verbose = :verbose
        else
          @@ronin_verbose = :quiet
        end

        return mode
      end

      #
      # Changes verbose output.
      #
      # @param [Boolean] mode
      #   The new quiet mode.
      #
      # @return [Boolean]
      #   The new quiet mode.
      #
      # @since 0.3.0
      #
      def Output.quiet=(mode)
        if mode
          @@ronin_verbose = :quiet
        else
          @@ronin_verbose = :verbose
        end

        return mode
      end

      #
      # Changes verbose output.
      #
      # @param [Boolean] mode
      #   The new quiet mode.
      #
      # @return [Boolean]
      #   The new quiet mode.
      #
      # @since 0.3.0
      #
      def Output.silent=(mode)
        if mode
          @@ronin_verbose = :silent
        else
          @@ronin_verbose = :quiet
        end

        return mode
      end

      #
      # @return [Ronin::UI::Output::Handler]
      #   The current Output handler.
      #
      # @since 0.3.0
      #
      def Output.handler
        @@ronin_output ||= Handler
      end

      #
      # Sets the current Output handler.
      #
      # @param [Handler] new_handler
      #   The new output handler to use. Must provide the `puts`,
      #   `print_info`, `print_debug`, `print_warning` and `print_error`
      #   class methods.
      #
      # @since 0.3.0
      #
      def Output.handler=(new_handler)
        @@ronin_output = new_handler
      end
    end
  end
end

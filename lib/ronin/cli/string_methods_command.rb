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

require_relative 'string_processor_command'
require_relative 'method_options'

module Ronin
  class CLI
    #
    # Base class for all commands that process strings by calling one or more
    # methods on them.
    #
    class StringMethodsCommand < StringProcessorCommand

      include MethodOptions

      #
      # Processes the string.
      #
      # @param [String] string
      #   The string to process.
      #
      # @return [String]
      #   The end result string.
      #
      def process_string(string)
        apply_method_options(string)
      end

    end
  end
end

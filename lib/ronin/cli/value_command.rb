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

require 'ronin/cli/command'

require 'command_kit/options/input'

module Ronin
  class CLI
    module Commands
      #
      # Represents a command which accepts one or more "values" (aka Strings
      # that cannot contain a new-line) from the command-line, an input file
      # or from `stdin`.
      #
      class ValueCommand < Command

        include CommandKit::Options::Input

        #
        # Runs the command
        #
        # @param [Array<String>] args.
        #   Additional arguments to process.
        #
        def run(*args)
          if !args.empty?
            args.each(&method(:process_value))
          elsif !input_files.empty?
            open_input_stream(*input_files) do |input|
              input.each_line(chomp: true, &method(:process_value))
            end
          else
            print_error "must specify either additional arguments or the --input option"
            exit(1)
          end
        end

        #
        # Processes an individual value.
        #
        # @param [String] value
        #   The string value to process.
        #
        # @abstract
        #
        def process_value(value)
          raise(NotImplementedError,"#{self.class}##{__method__} was not implemented")
        end

      end
    end
  end
end

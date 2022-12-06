# frozen_string_literal: true
#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  class CLI
    #
    # Represents a command which accepts one or more values from the
    # command-line or a file.
    #
    class ValueProcessorCommand < Command

      option :file, short: '-f',
                    value: {
                      type:  String,
                      usage: 'FILE'
                    },
                    desc: 'Optional file to read values from' do |path|
                      @files << path
                    end

      # The additional files to process.
      #
      # @return [Array<String>]
      attr_reader :files

      # 
      # Initializes the command.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      def initialize(**kwargs)
        super(**kwargs)

        @files = []
      end

      #
      # Runs the command
      #
      # @param [Array<String>] args.
      #   Additional arguments to process.
      #
      def run(*values)
        if (values.empty? && @files.empty?)
          print_error "must specify one or more arguments, or the --file option"
          exit(1)
        end

        @files.each(&method(:process_file))
        values.each(&method(:process_value))
      end

      #
      # Reads and processes each line of the file.
      #
      # @param [String] path
      #   The path to the file.
      #
      def process_file(path)
        File.open(path) do |file|
          file.each_line(chomp: true, &method(:process_value))
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
        raise(NotImplementedError,"#{self.class}##{__method__} method was not implemented")
      end

    end
  end
end

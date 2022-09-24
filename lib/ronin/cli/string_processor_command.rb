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

require 'ronin/cli/file_processor_command'

module Ronin
  class CLI
    #
    # Base class for all commands that process strings.
    #
    class StringProcessorCommand < FileProcessorCommand

      #
      # A value object that represents a literal String input value.
      #
      class StringValue

        # The literal string value.
        #
        # @return [String]
        attr_reader :string

        #
        # Initializes the stirng value.
        #
        # @param [String] string
        #   The string value.
        #
        def initialize(string)
          @string = string
        end

      end

      #
      # A value object that represents a file to process.
      #
      class FileValue

        # The file's path.
        #
        # @return [String]
        attr_reader :file

        #
        # Initializes the file value.
        #
        # @param [String] file
        #   The path to the file.
        #
        def initialize(file)
          @file = file
        end

      end

      usage '[options] [FILE ...]'

      option :file, short: '-f',
                    value: {
                      type: String,
                      usage: 'FILE'
                    },
                    desc: 'Optional file to process' do |file|
                      @input_values << FileValue.new(file)
                    end

      option :string, value: {
                        type:  String,
                        usage: 'STRING'
                      },
                      desc: 'Optional string to process' do |string|
                        @input_values << StringValue.new(string)
                      end

      option :multiline, short: '-M',
                         desc: 'Process each line separately'

      option :keep_newlines, short: '-n',
                             desc: 'Preserves newlines at the end of each line'

      argument :file, required: false,
                      repeats:  true,
                      desc:     'Optional file(s) to process'

      # The input values to process.
      #
      # @return [Array<StringValue, FileValue>]
      attr_reader :input_values

      #
      # Initializes the string processor command.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments.
      #
      def initialize(**kwargs)
        super(**kwargs)

        @input_values = []
      end

      #
      # Runs the command.
      #
      # @param [Array<String>] files
      #   Additional files to proceess.
      #
      def run(*files)
        if (files.empty? && @input_values.empty?)
          process_input(stdin)
        else
          @input_values.each do |value|
            case value
            when StringValue
              print_string(process_string(value.string))
            when FileValue
              process_file(value.file)
            end
          end

          files.each(&method(:process_file))
        end
      end

      #
      # Processes an input stream.
      #
      # @param [IO] input
      #   The input stream to read and process.
      #
      def process_input(input)
        if options[:multiline]
          input.each_line(chomp: !options[:keep_newlines]) do |line|
            print_string(process_string(line))
          end
        else
          print_string(process_string(input.read))
        end
      end

      #
      # Prints a string value.
      #
      # @param [String] string
      #   The string value to print.
      #
      def print_string(string)
        puts string
      end

      #
      # Processes the string.
      #
      # @param [String] string
      #   The string to process.
      #
      # @return [String]
      #   The end result string.
      #
      # @abstract
      #
      def process_string(string)
        raise(NotImplementedError,"#{self.class}##{__method__} method was not implemented")
      end

    end
  end
end

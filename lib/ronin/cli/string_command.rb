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
require 'ronin/cli/method_options'

require 'command_kit/options/input'
require 'command_kit/options/output'

module Ronin
  class CLI
    #
    # Base class for all commands that process strings.
    #
    class StringCommand < Command

      include CommandKit::Options::Input
      include CommandKit::Options::Output
      include MethodOptions

      usage '[options] [STRING ... | -i FILE]'

      option :multiline, short: '-M',
                         desc: 'Process each line separately'

      option :keep_newlines, short: '-n',
                             desc: 'Preserves newlines at the end of each line'

      argument :string, required: false,
                        repeats:  true,
                        desc:     'Optional string value(s) to process'

      #
      # Runs the command.
      #
      # @param [String, nil] args
      #   The strings to process.
      #
      def run(*strings)
        if !strings.empty?
          open_output_stream(options[:output]) do |output|
            strings.each do |data|
              output.puts(process_string(data))
            end
          end
        else
          open_output_stream(options[:output]) do |output|
            print_newline = (output.tty? || input_files.length > 1)

            open_input_stream(*input_files) do |input|
              if options[:multiline]
                input.each_line(chomp: !options[:keep_newlines]) do |line|
                  output.puts(process_string(line))
                end
              else
                string = process_string(input.read)

                if print_newline then output.puts(string)
                else                  output.print(string)
                end
              end
            end
          end
        end
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
      def process_string(string)
        apply_method_options(string)
      end

    end
  end
end

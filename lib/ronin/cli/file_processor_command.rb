# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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
    class FileProcessorCommand < Command

      argument :file, required: false,
                      repeats:  true,
                      desc:     'Option file(s) to process'

      #
      # Runs the command and processes files or stdin.
      #
      # @param [Array<String>] files
      #   Optional files to process.
      #
      def run(*files)
        if files.empty?
          process_input(stdin)
        else
          files.each(&method(:process_file))
        end
      end

      #
      # Opens a file for reading.
      #
      # @param [Stirng] path
      #   The path to the file to open.
      #
      # @param [String] mode
      #   The mode to open the file with.
      #
      # @yield [file]
      #   If a block is given, the newly opened file will be yielded.
      #   Once the block returns the file will automatically be closed.
      #
      # @yieldparam [File] file
      #   The newly opened file.
      #
      # @return [File, nil]
      #   If no block is given, the newly opened file object will be returned.
      #   If no block was given, then `nil` will be returned.
      #
      def open_file(path,mode='r',&block)
        File.open(path,mode,&block)
      rescue Errno::ENOENT
        print_error "no such file or directory: #{path}"
        exit(1)
      end

      #
      # Processes a file.
      #
      # @param [String] path
      #   The path to the file to read and process.
      #
      def process_file(path)
        open_file(path,&method(:process_input))
      end

      #
      # Processes an input stream.
      #
      # @param [File, IO] input
      #   The opened file or the `stdin` input stream.
      #
      # @abstract
      #
      def process_input(input)
        raise(NotImplementedError,"#{self.class}##{__method__} method was not implemented")
      end

    end
  end
end

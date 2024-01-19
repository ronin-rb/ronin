# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/support/archive'

module Ronin
  class CLI
    module Commands
      #
      # Unarchive the files.
      #
      # ## Usage
      #
      #     ronin unarchive [options] FILE ...
      #
      ## Options
      #
      #     -f, --format tar|zip             Explicit archive format
      #
      # ## Arguments
      #
      #     FILE ...                         File(s) to unarchive
      #
      class Unarchive < FileProcessorCommand

        ALLOWED_EXTENSIONS  = ['.tar', '.zip']

        usage '[options] FILE ...'

        argument :file, required: true,
                        repeats:  true,
                        desc:     'Archive files to unarchive'

        option :format, short: '-f',
                        value: {
                          type: [:tar, :zip]
                        },
                        desc: 'Archive type'

        description 'Unarchive the data'

        man_page 'ronin-unarchive.1'

        #
        # Runs the `unarchive` sub-command.
        #
        # @param [Array<String>] files
        #   File arguments.
        #
        def run(*files)
          files.each do |file|
            extension = File.extname(file)

            unless ALLOWED_EXTENSIONS.include?(extension)
              print_error("Invalid file '#{file}'.")
              next
            end

            open_archive(file) do |archived_files|
              archived_files.each do |archived_file|
                File.binwrite(archived_file.name, archived_file.read)
              end
            end
          end
        end

        #
        # Opens archive for read.
        #
        # @param [String] file
        #   File to open.
        #
        # @yield [archived_file]
        #   Yielded archived file.
        #
        # @yieldparam [Zip::Reader, Tar::Reader] reader
        #   Zip or tar reader object.
        #
        def open_archive(file,&block)
          case options[:format]
          when :tar
            Support::Archive.untar(file,&block)
          when :zip
            Support::Archive.unzip(file,&block)
          end
        end
      end
    end
  end
end

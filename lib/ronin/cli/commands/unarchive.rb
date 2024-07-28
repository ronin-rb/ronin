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

require_relative '../file_processor_command'
require 'ronin/support/archive'

module Ronin
  class CLI
    module Commands
      #
      # Unarchive the file(s).
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
      # @since 2.1.0
      #
      class Unarchive < FileProcessorCommand

        usage '[options] FILE ...'

        argument :file, required: true,
                        repeats:  true,
                        desc:     'Archive files to unarchive'

        option :format, short: '-f',
                        value: {
                          type: [:tar, :zip]
                        },
                        desc: 'Archive type'

        description 'Unarchive the archive file(s)'

        man_page 'ronin-unarchive.1'

        #
        # Runs the `unarchive` sub-command.
        #
        # @param [Array<String>] files
        #   File arguments.
        #
        def run(*files)
          files.each do |file|
            open_archive(file) do |archived_files|
              archived_files.each do |archived_file|
                File.binwrite(archived_file.name, archived_file.read)
              end
            end
          end
        end

        # Archive file formats and archive types.
        ARCHIVE_FORMATS = {
          '.tar' => :tar,
          '.zip' => :zip
        }

        #
        # Returns the format for the given archive path.
        #
        # @param [String] path
        #   The path to the archive file.
        #
        # @return [:tar, :zip, nil]
        #   The archive format. `nil` is returned if the format cannot be
        #   guessed and the `--format` option was not given.
        #
        def format_for(path)
          options.fetch(:format) do
            ARCHIVE_FORMATS[File.extname(path)]
          end
        end

        #
        # Opens archive for read.
        #
        # @param [String] file
        #   File to open.
        #
        # @yield [archive_reader]
        #   Yielded archived file.
        #
        # @yieldparam [Ronin::Support::Archive::Zip::Reader,
        #              Ronin::Support::Archive::Tar::Reader] archive_reader
        #   Zip or tar reader object.
        #
        def open_archive(file,&block)
          format = format_for(file)

          case format
          when :tar
            Support::Archive.untar(file,&block)
          when :zip
            Support::Archive.unzip(file,&block)
          when nil
            print_error("unknown archive format: #{file}")
          else
            raise(NotImplementedError,"archive format not supported: #{format.inspect}")
          end
        end
      end
    end
  end
end

# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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
      # Archive the files.
      #
      # ## Usage
      #
      #     ronin archive [option] [FILE ...]
      #
      # ## Options
      #
      #     -f, --format tar|zip             Archive format
      #     -o, --output PATH                Archived file path
      #
      # ## Arguments
      #
      #     FILE ...                         Optional file(s) to archive
      #
      # @since 2.1.0
      #
      class Archive < FileProcessorCommand

        usage '[options] [FILE ...]'

        option :format, short: '-f',
                        value: {
                          type: [:tar, :zip]
                        },
                        desc: 'Archive format'

        option :output, short: '-o',
                        value: {
                          type: String,
                          usage: 'PATH'
                        },
                        desc: 'Archived file path'

        description 'Archive the data'

        man_page 'ronin-archive.1'

        # Mapping of archive file extensions and their formats.
        ARCHIVE_FORMATS = {
          '.tar' => :tar,
          '.zip' => :zip
        }

        #
        # Runs the `archive` sub-command.
        #
        # @param [Array<String>] files
        #   File arguments.
        #
        def run(*files)
          unless (output = options[:output])
            print_error "must specify the --output option"
            exit(-1)
          end

          format = options.fetch(:format) do
                     ARCHIVE_FORMATS.fetch(File.extname(output)) do
                       print_error "must either specify --format or a .tar or .zip output file"
                       exit(1)
                     end
                   end

          unless files.empty?
            Ronin::Support::Archive.send(format,output) do |archive|
              files.each do |file|
                archive.add_file(file) do |io|
                  File.open(file, 'rb') do |opened_file|
                    io.write(opened_file.readpartial(4096)) until opened_file.eof?
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

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

require 'ronin/cli/file_processor_command'
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
      #     -t, --tar                        tar archive the data
      #     -z, --zip                        zip archive the data
      #     -n, --name                       Archived file name
      #
      # ## Arguments
      #
      #     [FILE ...]                       Optional file(s) to archive
      #
      class Archive < FileProcessorCommand
        usage '[options] [FILE ...]'

        option :tar, short: '-t',
                      desc: 'tar archive the data' do
                        @archive_method = :tar
                      end

        option :zip, short: '-z',
                      desc: 'zip archive the data' do
                        @archive_method = :zip
                      end

        option :output, short: '-o',
                        value: {
                          type: String
                        },
                        desc: 'archived file name'

        description 'Archive the data'

        man_page 'ronin-archive.1'

        #
        # The archive format.
        #
        # @return [:tar, :zip]
        #
        attr_reader :archive_method

        #
        # Initializes the `ronin archive` command.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @archive_method = :tar
        end

        #
        # Runs the `archive` sub-command.
        #
        # @param [Array<String>] files
        #   File arguments.
        #

        def run(*files)
          unless files.empty?
            filename = options[:output] || "#{files.first}.#{@archive_method}"

            Ronin::Support::Archive.send(@archive_method, filename) do |archive|
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

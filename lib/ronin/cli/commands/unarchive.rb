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
      # Unarchive the files.
      #
      # ## Usage
      #
      #     ronin unarchive [FILE ...]
      #
      # ## Arguments
      #
      #     [FILE ...]                       File(s) to unarchive
      #
      class Unarchive < FileProcessorCommand
        ALLOWED_EXTENSIONS  = ['.tar', '.zip']
        EXTENSIONS_MAPPINGS = {
          '.tar' => :untar,
          '.zip' => :unzip
        }

        usage '[FILE ...]'

        description 'Unarchive the data'

        man_page 'ronin-unarchive.1'

        #
        # Runs the `unarchive` sub-command.
        #
        # @param [Array<String>] files
        #   File arguments.
        #

        def run(*files)
          unless files.empty?
            files.each do |file|
              extension = File.extname(file)
              next unless ALLOWED_EXTENSIONS.include?(extension)

              Ronin::Support::Archive.send(EXTENSIONS_MAPPINGS[extension], file) do |archived_files|
                archived_files.each do |archived_file|
                  File.write(archived_file.name, archived_file.read)
                end
              end
            end
          end
        end
      end
    end
  end
end

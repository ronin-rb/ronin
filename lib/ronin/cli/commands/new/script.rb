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
require 'ronin/core/cli/generator'
require 'ronin/root'

module Ronin
  class CLI
    module Commands
      #
      # Creates new standalone scripts.
      #
      # ## Usage
      #
      #     ronin new script PATH
      #
      # ## Arguments
      #
      #     PATH                             The script file to create
      #
      class New < Command
        class Script < Command

          include Core::CLI::Generator

          template_dir File.join(ROOT,'data','new')

          usage' PATH'

          argument :path, required: true,
                          desc:     'The script file to create'

          man_page 'ronin-new-script.1'

          #
          # Runs the `ronin new script` command.
          #
          # @param [String] path
          #   The path to the new script file to create.
          #
          def run(path)
            erb 'script.rb.erb', path
            chmod '+x', path
          end

        end
      end
    end
  end
end

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

require_relative '../../command'

require 'ronin/core/cli/generator'
require 'ronin/root'

module Ronin
  class CLI
    module Commands
      class New < Command
        #
        # Creates a new standalone Ruby script.
        #
        # ## Usage
        #
        #     ronin new script PATH
        #
        # ## Arguments
        #
        #     PATH                             The script file to create
        #
        class Script < Command

          include Core::CLI::Generator

          template_dir File.join(ROOT,'data','templates')

          usage 'PATH'

          argument :path, required: true,
                          desc:     'The script file to create'

          description 'Creates a new standalone Ruby script'

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

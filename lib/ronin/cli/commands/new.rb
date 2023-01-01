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
require 'command_kit/commands/auto_load'

module Ronin
  class CLI
    module Commands
      #
      # Creates new projects or scripts.
      #
      # ## Usage
      #
      #     ronin new {project [options] DIR | script FILLE}
      #
      # ## Options
      #
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #
      #     [COMMAND]                        The command name to run
      #     [ARGS ...]                       Additional arguments for the command
      #
      # ## Commands
      #
      #     help
      #     project
      #     script
      #
      class New < Command

        include CommandKit::Commands::AutoLoad.new(
          dir:       "#{__dir__}/new",
          namespace: "#{self}"
        )

        examples [
          'project foo',
          'script foo.rb'
        ]

        man_page 'ronin-new.1'

      end
    end
  end
end

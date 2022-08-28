#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'command_kit/commands'
require 'command_kit/commands/auto_load'

module Ronin
  #
  # The main CLI logic for the `ronin` command.
  #
  # @api private
  #
  # @since 2.0.0
  #
  class CLI

    include CommandKit::Commands
    include CommandKit::Commands::AutoLoad.new(
      dir:       "#{__dir__}/cli/commands",
      namespace: "#{self}::Commands"
    )

    command_name 'ronin'

    ADDITIONAL_RONIN_COMMANDS = %w[
      ronin-repos
      ronin-db
      ronin-web
      ronin-fuzzer
      ronin-payloads
      ronin-exploits
    ]

    #
    # Prints the regular `--help` output but also lists other `ronin-*`
    # commands.
    #
    def help
      super

      puts
      puts "Additional Ronin Commands:"
      ADDITIONAL_RONIN_COMMANDS.each do |name|
        puts "    $ #{name}"
      end
      puts
    end

  end
end

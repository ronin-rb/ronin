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

require 'ronin/version'
require 'ronin/core/cli/help/banner'

require 'command_kit/commands'
require 'command_kit/commands/auto_load'
require 'command_kit/options/version'

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
    include CommandKit::Options::Version
    include Core::CLI::Help::Banner

    command_name 'ronin'
    version Ronin::VERSION

    command_aliases['enc'] = 'encode'
    command_aliases['dec'] = 'decode'
    command_aliases['nc']  = 'netcat'

    command_aliases['tlds']            = 'tld-list'
    command_aliases['public-suffixes'] = 'public-suffix-list'

    # Additional `ronin-` commands to checkout.
    ADDITIONAL_RONIN_COMMANDS = %w[
      ronin-repos
      ronin-db
      ronin-web
      ronin-fuzzer
      ronin-masscan
      ronin-nmap
      ronin-payloads
      ronin-exploits
      ronin-vulns
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

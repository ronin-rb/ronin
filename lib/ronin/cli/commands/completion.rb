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

require 'ronin/core/cli/completion_command'
require 'ronin/repos/cli/commands/completion'
require 'ronin/wordlists/cli/commands/completion'
require 'ronin/db/cli/commands/completion'
require 'ronin/fuzzer/cli/commands/completion'
require 'ronin/web/cli/commands/completion'
require 'ronin/vulns/cli/commands/completion'
require 'ronin/payloads/cli/commands/completion'
require 'ronin/exploits/cli/commands/completion'
require 'ronin/listener/cli/commands/completion'
require 'ronin/nmap/cli/commands/completion'
require 'ronin/masscan/cli/commands/completion'
require 'ronin/recon/cli/commands/completion'
require 'ronin/root'

module Ronin
  class CLI
    module Commands
      #
      # Manages the shell completion rule for `ronin` and all other `ronin-*`
      # commands.
      #
      # ## Usage
      #
      #     ronin completion [options]
      #
      # ## Options
      #
      #         --print                      Prints the shell completion file
      #         --install                    Installs the shell completion file
      #         --uninstall                  Uninstalls the shell completion file
      #     -h, --help                       Print help information
      #
      # ## Examples
      #
      #     ronin completion --print
      #     ronin completion --install
      #     ronin completion --uninstall
      #
      # @since 2.1.0
      #
      class Completion < Core::CLI::CompletionCommand

        man_dir File.join(ROOT,'man')
        man_page 'ronin-completion.1'

        description 'Manages the shell completion rules for ronin and all other ronin-* commands'

        # All shell completion files for `ronin` and the other `ronin-*`
        # commands.
        COMPLETION_FILES = [
          File.join(ROOT,'data','completions','ronin'),

          Repos::CLI::Commands::Completion.completion_file,
          Wordlists::CLI::Commands::Completion.completion_file,
          DB::CLI::Commands::Completion.completion_file,
          Fuzzer::CLI::Commands::Completion.completion_file,
          Web::CLI::Commands::Completion.completion_file,
          Vulns::CLI::Commands::Completion.completion_file,
          Payloads::CLI::Commands::Completion.completion_file,
          Exploits::CLI::Commands::Completion.completion_file,
          Listener::CLI::Commands::Completion.completion_file,
          Nmap::CLI::Commands::Completion.completion_file,
          Masscan::CLI::Commands::Completion.completion_file,
          Recon::CLI::Commands::Completion.completion_file
        ]

        #
        # Prints all completion files.
        #
        def print_completion_file
          COMPLETION_FILES.each do |completion_file|
            super(completion_file)
          end
        end

        #
        # Installs all completion files.
        #
        def install_completion_file
          COMPLETION_FILES.each do |completion_file|
            super(completion_file)
          end
        end

        #
        # Uninstall all completion files.
        #
        def uninstall_completion_file
          COMPLETION_FILES.each do |completion_file|
            super(completion_file)
          end
        end
      end
    end
  end
end

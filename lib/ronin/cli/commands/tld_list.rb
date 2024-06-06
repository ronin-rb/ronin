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
require 'ronin/core/cli/logging'
require 'ronin/support/network/tld/list'

require 'command_kit/options/verbose'

module Ronin
  class CLI
    module Commands
      #
      # Updates and parses the TLD list file.
      #
      # ## Usage
      #
      #     ronin tld-list [options]
      #
      # ## Options
      #
      #     -v, --verbose                    Enables verbose output
      #     -u, --update                     Updates the TLD list file
      #     -U, --url URL                    URL to the TLD list (Default: https://data.iana.org/TLD/tlds-alpha-by-domain.txt)
      #     -p, --path FILE                  Path to the TLD list file (Default: ~/.cache/ronin/ronin-support/tlds-alpha-by-domain.txt)
      #     -h, --help                       Print help information
      #
      class TldList < Command

        include Ronin::Support::Network::TLD
        include CommandKit::Options::Verbose
        include Core::CLI::Logging

        command_name 'tld-list'

        option :update, short: '-u',
                        desc: 'Updates the TLD list file'

        option :url, short: '-U',
                     value: {
                       type:  String,
                       usage: 'URL',
                       default: List::URL
                     },
                     desc: 'URL to the TLD list'

        option :path, short: '-p',
                      value: {
                        type:  String,
                        usage: 'FILE',
                        default: List::PATH
                      },
                      desc: 'Path to the TLD list file'

        description "Updates and parses the TLD list file"

        man_page 'ronin-tld-list.1'

        #
        # Runs the `ronin tld-list` command.
        #
        def run
          if !downloaded?
            download
          elsif options[:update] || stale?
            update
          end

          list_file = List.load_file(options[:path])

          list_file.each do |tld|
            puts tld
          end
        end

        #
        # Determines if the TLD list file has been downloaded already.
        #
        # @return [Boolean]
        #
        def downloaded?
          List.downloaded?(options[:path])
        end

        #
        # Determines if the TLD list file is stale.
        #
        # @return [Boolean]
        #
        def stale?
          List.stale?(options[:path])
        end

        #
        # Downloads the TLD list file.
        #
        def download
          if verbose?
            log_info "Downloading TLD list from #{options[:url]} to #{options[:path]} ..."
          end

          List.download(url: options[:url], path: options[:path])
        end

        #
        # Updates the TLD list file.
        #
        def update
          if verbose?
            log_info "Updating TLD list file #{options[:path]} ..."
          end

          List.update(path: options[:path])
        end

      end
    end
  end
end

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

require 'ronin/cli/command'
require 'ronin/core/cli/logging'
require 'ronin/support/network/public_suffix/list'

require 'command_kit/options/verbose'

module Ronin
  class CLI
    module Commands
      #
      # Updates and parses the public suffix list file.
      #
      # ## Usage
      #
      #     ronin public-suffix [options]
      #
      # ## Options
      #
      #     -v, --verbose                    Enables verbose output
      #     -u, --update                     Updates the public suffix list file
      #     -U, --url URL                    URL to the public suffix list (Default: https://publicsuffix.org/list/public_suffix_list.dat)
      #     -p, --path FILE                  Path to the public suffix list file (Default: /home/postmodern/.local/share/ronin/ronin-support/public_suffix_list.dat)
      #     -h, --help                       Print help information
      #
      class PublicSuffix < Command

        include Ronin::Support::Network::PublicSuffix
        include CommandKit::Options::Verbose
        include Core::CLI::Logging

        command_name 'public-suffix'

        option :update, short: '-u',
                        desc: 'Updates the public suffix list file'

        option :url, short: '-U',
                     value: {
                       type:  String,
                       usage: 'URL',
                       default: List::URL
                     },
                     desc: 'URL to the public suffix list'

        option :path, short: '-p',
                      value: {
                        type:  String,
                        usage: 'FILE',
                        default: List::PATH
                      },
                      desc: 'Path to the public suffix list file'

        description "Updates and parses the public suffix list file"

        man_page 'ronin-public-suffix.1'

        def run(*args)
          if !File.file?(options[:path])
            download
          elsif options[:update] || stale?
            update
          end

          list_file = List.load_file(options[:path])

          list_file.each do |suffix|
            puts suffix
          end
        end

        #
        # Determines if the public suffix list file is stale.
        #
        def stale?
          List.stale?(options[:path])
        end

        #
        # Downloads the public suffix list file.
        #
        def download
          if verbose?
            log_info "Downloading public suffix list from #{options[:url]} to #{options[:path]} ..."
          end

          List.download(url: options[:url], path: options[:path])
        end

        #
        # Updates the public suffix list file.
        #
        def update
          if verbose?
            log_info "Updating public suffix list file #{options[:path]} ..."
          end

          List.update(path: options[:path])
        end

      end
    end
  end
end

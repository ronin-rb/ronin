# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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
        # Creates a new [ronin-dns-proxy] script.
        #
        # [ronin-dns-proxy]: https://github.com/ronin-rb/ronin-dns-proxy#readme
        #
        # ## Usage
        #
        #     ronin new dns-proxy PATH
        #
        # ## Options
        #
        #     -H, --host IP                    The IP to listen on (Default: 127.0.0.1)
        #     -p, --port PORT                  The port number to listen on (Default: 2345)
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     PATH                             The script file to create
        #
        # @since 2.1.0
        #
        class DnsProxy < Command

          include Core::CLI::Generator

          template_dir File.join(ROOT,'data','templates')

          command_name 'dns-proxy'

          usage 'PATH'

          option :host, short: '-H',
                        value: {
                          type:    String,
                          usage:   'IP',
                          default: '127.0.0.1'
                        },
                        desc: 'The IP to listen on'

          option :port, short: '-p',
                        value: {
                          type:    Integer,
                          usage:   'PORT',
                          default: 2345
                        },
                        desc: 'The port number to listen on'

          argument :path, required: true,
                          desc:     'The script file to create'

          description 'Creates a new ronin-dns-proxy script'

          man_page 'ronin-new-dns-proxy.1'

          #
          # Runs the `ronin new dns-proxy` command.
          #
          # @param [String] path
          #   The path to the new script file to create.
          #
          def run(path)
            @host = options[:host]
            @port = options[:port]

            erb 'dns_proxy.rb.erb', path
            chmod '+x', path
          end

        end
      end
    end
  end
end

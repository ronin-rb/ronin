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

require 'ronin/cli/value_processor_command'

require 'ronin/support/network/tcp'

module Ronin
  class CLI
    module Commands
      #
      # Fetches the banner from one or more TCP services.
      #
      # ## Usage
      #
      #     ronin banner-grab [options] {HOST:PORT} ...
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to read values from
      #         --with-host-port             Print the service with each banner
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     HOST:PORT ...                    A TCP service to fetch the banner from.
      #
      class BannerGrab < ValueProcessorCommand

        usage '[options] {HOST:PORT} ...'

        option :with_host_port, desc: 'Print the service with the banner'

        argument :service, required: true,
                           repeats:  true,
                           usage:    'HOST:PORT',
                           desc:     'A TCP service to fetch the banner from'

        description 'Fetches the banner from one or more TCP services'

        man_page 'ronin-banner-grab.1'

        #
        # Grabs the banner for the service.
        #
        # @param [String] service
        #   The `HOST:PORT` service pair.
        #
        def process_value(service)
          host, port = service.split(':',2)
          port = port.to_i

          begin
            banner = Support::Network::TCP.banner(host,port)

            if options[:with_host_port]
              puts "#{service}: #{banner}"
            else
              puts banner
            end
          rescue => error
            print_error("#{service}: #{error.message}")
          end
        end

      end
    end
  end
end

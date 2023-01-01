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

require 'ronin/cli/value_processor_command'
require 'ronin/support/network/ssl/mixin'

require 'uri'

module Ronin
  class CLI
    module Commands
      #
      # Downloads the SSL/TLS certificate for a SSL/TLS service or `https://`
      # URL.
      #
      # ## Usage
      #
      #     ronin cert-grab [options] {HOST:PORT | URL} ...
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to read values from
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     HOST:PORT | URL ...              A HOST:PORT or URL
      #
      # ## Examples
      #
      #     ronin cert-grab github.com:443
      #     ronin cert-grab 93.184.216.34:443
      #     ronin cert-grab https://github.com/
      #
      class CertGrab < ValueProcessorCommand

        include Support::Network::SSL::Mixin

        usage '[options] {HOST:PORT | URL} ...'

        argument :target, required: true,
                          repeats:  true,
                          usage:   'HOST:PORT | URL',
                          desc:    'A HOST:PORT or URL'

        description "Downloads SSL/TLS certificates"

        examples [
          'github.com:443',
          '93.184.216.34:443',
          'https://github.com/',
        ]

        man_page 'ronin-cert-grab.1'

        #
        # Runs the `ronin cert-grab` command.
        #
        # @param [String] value
        #   The `HOST:PORT` or `URL` value to process.
        #
        def process_value(value)
          case value
          when /\A[^:]+:\d+\z/
            host, port = value.split(':',2)
            port = port.to_i

            grab_cert(host,port)
          when /\Ahttps:/
            uri = URI.parse(value)
            host = uri.host
            port = uri.port

            grab_cert(host,port)
          else
            print_error "invalid target: must be a HOST:PORT or a URL: #{value.inspect}"
            exit(1)
          end
        end

        #
        # The output file for the given host and port.
        #
        # @param [String] host
        #
        # @param [Integer] port
        #
        # @return [String]
        #   The output `.crt` file to save the certificate to.
        #
        def cert_file_for(host,port)
          "#{host}:#{port}.crt"
        end

        #
        # Downloads the certificate for the given host and port.
        #
        # @param [String] host
        #   The host to connect to.
        #
        # @param [Integer] port
        #   The port to connect to.
        #
        def grab_cert(host,port)
          cert = ssl_cert(host,port)

          cert.save(cert_file_for(host,port))
        end

      end
    end
  end
end

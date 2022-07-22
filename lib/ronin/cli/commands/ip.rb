#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin.
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

require 'ronin/cli/value_command'
require 'ronin/support/network/ip'
require 'uri'

module Ronin
  class CLI
    module Commands
      #
      # Queries or processes IP addresses.
      #
      # ## Usage
      #
      #     ronin ip [options] {[IP ...] | --public | --local}
      #
      # ## Options
      #
      #     -i, --input FILE                 Optional input file
      #     -P, --public                     Gets the machine's public IP address
      #     -L, --local                      Gets the machine's local IP address
      #     -r, --reverse                    Prints the IP address in reverse name format
      #     -u, --uint                       Converts the IP address to an unsigned integer
      #     -C, --cidr NETMASK               Converts the IP address into a CIDR range
      #     -H, --host                       Converts the IP address to a host name
      #     -p, --port PORT                  Appends the port number to each IP
      #     -U, --uri SCHEME                 Converts the IP address into a URI
      #         --http                       Converts the IP address into a http:// URI
      #         --https                      Converts the IP address into a https:// URI
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [IP ...]                         The IP address(es) to process
      #
      # ## Examples
      #
      #     ronin ip --public
      #     ronin ip --local
      #     ronin ip --uint 1.2.3.4
      #     ronin ip --cidr 20 1.2.3.4
      #     ronin ip --host 192.30.255.113
      #
      class Ip < ValueCommand

        usage '[options] {[IP ...] | --public | --local}'

        option :public, short: '-P',
                        desc: "Gets the machine's public IP address"

        option :local, short: '-L',
                       desc:  "Gets the machine's local IP address"

        option :reverse, short: '-r',
                         desc:  'Prints the IP address in reverse name format'

        option :uint, short: '-u',
                      desc:  'Converts the IP address to an unsigned integer'

        option :cidr, short: '-C',
                      value: {
                        type:  String,
                        usage: 'NETMASK'
                      },
                      desc: 'Converts the IP address into a CIDR range'

        option :host, short: '-H',
                      desc:  'Converts the IP address to a host name'

        option :port, short: '-p',
                      value: {
                        type:  Integer,
                        usage: 'PORT'
                      },
                      desc:  'Appends the port number to each IP'

        option :uri, short: '-U',
                     value: {
                       type:  String,
                       usage: 'SCHEME'
                     },
                     desc: 'Converts the IP address into a URI'

        option :http, desc: 'Converts the IP address into a http:// URI'
        option :https, desc: 'Converts the IP address into a https:// URI'

        argument :ip, required: false,
                      repeats:  true,
                      desc:     'The IP address(es) to process'

        description 'Queries or processes IP addresses'

        examples [
          '--public',
          '--local',
          '--uint 1.2.3.4',
          '--cidr 20 1.2.3.4',
          '--host 192.30.255.113'
        ]

        #
        # Runs the `ronin ip` command.
        #
        # @param [Array<String>] ips
        #   Additional IP arguments to process.
        #
        def run(*ips)
          if options[:public]
            if (address = Support::Network::IP.public_address)
              puts address
            else
              print_error 'failed to lookup public IP address using https://ipinfo.io/ip'
              exit(1)
            end
          elsif options[:local]
            puts Support::Network::IP.local_address
          else
            super(*ips)
          end
        end

        #
        # Processes an individual IP address.
        #
        # @param [String] ip
        #
        def process_value(ip)
          ip = Support::Network::IP.new(ip)

          if options[:reverse]
            puts ip.reverse
          elsif options[:uint]
            puts ip.to_i
          elsif options[:cidr]
            ip = Support::Network::IP.new("#{ip}/#{options[:cidr]}")

            puts "#{ip}/#{ip.prefix}"
          elsif options[:host]
            puts ip.host
          elsif options[:port]
            puts "#{ip}:#{options[:port]}"
          elsif options[:uri]
            puts URI::Generic.build(scheme: options[:uri], host: ip.to_s)
          elsif options[:http]
            puts URI::HTTP.build(host: ip.to_s)
          elsif options[:https]
            puts URI::HTTPS.build(host: ip.to_s)
          else
            print_error "must specify --reverse, --uint, --cidr, --host, --port, --uri, --http, or --https"
            exit(1)
          end
        end

      end
    end
  end
end

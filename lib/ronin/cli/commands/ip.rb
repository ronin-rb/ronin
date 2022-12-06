# frozen_string_literal: true
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
      #     ronin ip [options] [IP ... | --public | --local]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to read values from
      #     -P, --public                     Gets the machine's public IP address
      #     -L, --local                      Gets the machine's local IP address
      #     -r, --reverse                    Prints the IP address in reverse name format
      #     -X, --hex                        Converts the IP address to hexadecimal format
      #     -D, --decimal                    Converts the IP address to decimal format
      #     -O, --octal                      Converts the IP address to octal format
      #     -B, --binary                     Converts the IP address to binary format
      #     -C, --cidr NETMASK               Converts the IP address into a CIDR range
      #     -H, --host                       Converts the IP address to a host name
      #     -p, --port PORT                  Appends the port number to each IP
      #     -U, --uri                        Converts the IP address into a URI
      #         --uri-scheme SCHEME          The scheme for the URI (Default: http)
      #         --uri-port PORT              The port for the URI
      #         --uri-path /PATH             The path for the URI (Default: /)
      #         --uri-query STRING           The query string for the URI
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
      #     ronin ip --decimal 1.2.3.4
      #     ronin ip --cidr 20 1.2.3.4
      #     ronin ip --host 192.30.255.113
      #
      class Ip < ValueProcessorCommand

        usage '[options] {IP ... | --public | --local}'

        option :public, short: '-P',
                        desc: "Gets the machine's public IP address"

        option :local, short: '-L',
                       desc:  "Gets the machine's local IP address"

        option :reverse, short: '-r',
                         desc:  'Prints the IP address in reverse name format'

        option :hex, short: '-X',
                     desc:  'Converts the IP address to hexadecimal format'

        option :decimal, short: '-D',
                         desc:  'Converts the IP address to decimal format'

        option :octal, short: '-O',
                       desc:  'Converts the IP address to octal format'

        option :binary, short: '-B',
                        desc:  'Converts the IP address to binary format'

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

        option :uri, short: '-U', desc: 'Converts the IP address into a URI'

        option :uri_scheme, value: {
                              type:    String,
                              default: 'http',
                              usage:   'SCHEME'
                            },
                            desc: 'The scheme for the URI'

        option :uri_port, value: {
                            type:  Integer,
                            usage: 'PORT'
                          },
                          desc: 'The port for the URI'

        option :uri_path, value: {
                            type:    %r{\A/.+},
                            default: '/',
                            usage:   '/PATH'
                          },
                          desc: 'The path for the URI'

        option :uri_query, value: {
                             type:  String,
                             usage: 'STRING'
                           },
                           desc: 'The query string for the URI'

        option :http, desc: 'Converts the IP address into a http:// URI' do
          options[:uri] = true
          options[:uri_scheme] = 'http'
        end

        option :https, desc: 'Converts the IP address into a https:// URI' do
          options[:uri] = true
          options[:uri_scheme] = 'https'
        end

        argument :ip, required: false,
                      repeats:  true,
                      desc:     'The IP address(es) to process'

        description 'Queries or processes IP addresses'

        examples [
          '--public',
          '--local',
          '--decimal 1.2.3.4',
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
        #   The IP address string to process.
        #
        def process_value(ip)
          ip = Support::Network::IP.new(ip)

          if options[:reverse]
            puts ip.reverse
          elsif options[:cidr]
            ip = Support::Network::IP.new("#{ip}/#{options[:cidr]}")

            puts "#{ip}/#{ip.prefix}"
          elsif options[:host]
            puts ip.host
          elsif options[:port]
            puts "#{format_ip(ip)}:#{options[:port]}"
          elsif options[:uri]
            puts URI::Generic.build(
              scheme: options[:uri_scheme],
              host:   format_ip(ip),
              port:   options[:uri_port],
              path:   options[:uri_path],
              query:  options[:uri_query]
            )
          else
            puts format_ip(ip)
          end
        end

        #
        # Formats an IP address.
        #
        # @param [Ronin::Support::Network::IP] ip
        #   The IP address to format.
        #
        # @return [String]
        #   The formatted IP address.
        #
        def format_ip(ip)
          if options[:hex]
            "0x%x" % ip.to_i
          elsif options[:decimal]
            "%u" % ip.to_i
          elsif options[:octal]
            "0%o" % ip.to_i
          elsif options[:binary]
            "%b" % ip.to_i
          else
            ip.to_s
          end
        end

      end
    end
  end
end

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
require 'ronin/cli/dns'
require 'ronin/support/network/dns'

module Ronin
  class CLI
    module Commands
      #
      # Queries DNS records for the given host name.
      #
      # ## Usage
      #
      #     ronin dns [options] [HOST [...]]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to read values from
      #     -N, --nameserver IP              Send DNS queries to the nameserver
      #     -t A|AAAA|ANY|CNAME|HINFO|LOC|MINFO|MX|NS|PTR|SOA|SRV|TXT|WKS,
      #         --type                       Queries a specific type of DNS record
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     HOST                             The host name to query
      #
      class Dns < ValueProcessorCommand

        include DNS

        usage '[options] HOST'

        option :type, short: '-t',
                      value: {
                        type: {
                          A:     :a,
                          AAAA:  :aaaa,
                          ANY:   :any,
                          CNAME: :cname,
                          HINFO: :hinfo,
                          LOC:   :loc,
                          MINFO: :minfo,
                          MX:    :mx,
                          NS:    :ns,
                          PTR:   :ptr,
                          SOA:   :soa,
                          SRV:   :srv,
                          TXT:   :txt,
                          WKS:   :wks
                        }
                      },
                      desc: 'Queries a specific type of DNS record'

        argument :host, required: true,
                        desc:     'The host name to query'

        description 'Performs a variety of DNS queries'

        man_page 'ronin-dns.1'

        #
        # Queries the given host.
        #
        # @param [String] host
        #
        def process_value(host)
          print_records(query_records(host))
        end

      end
    end
  end
end

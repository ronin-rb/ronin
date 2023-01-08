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
require 'ronin/support/network/host'

require 'wordlist/file'

module Ronin
  class CLI
    module Commands
      #
      # Processes hostname(s) and performs DNS queries.
      #
      # ## Usage
      #
      #     ronin host [options] [HOST ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to read values from
      #         --subdomain SUBNAME          Converts the hostname to a sub-domain
      #     -d, --domain                     Converts the hostname to a domain
      #     -T, --tld                        Converts the hostname to it's TLD 
      #     -s, --suffix                     Converts the hostname to it's suffix
      #     -S, --change-suffix SUFFIX       Changes the suffix of each hostname
      #         --enum-tlds                  Enumerates over every TLD 
      #         --enum-suffixes[={icann|private}]
      #                                      Enumerates over every domain suffix
      #         --enum-subdomains FILE       Enumerates over every subdomain in the wordlist
      #     -N, --nameserver HOST|IP         Send DNS queries to the nameserver
      #     -I, --ips                        Converts the hostname to it's IP addresses
      #     -r, --registered                 Filters hostnames that are registered
      #     -u, --unregistered               Filters hostnames that are unregistered
      #     -A, --has-addresses              Filters hostnames that have addresses
      #     -H A|AAAA|ANY|CNAME|HINFO|LOC|MINFO|MX|NS|PTR|SOA|SRV|TXT|WKS,
      #         --has-records                Filters hostnames that have a certain DNS record type
      #     -t A|AAAA|ANY|CNAME|HINFO|LOC|MINFO|MX|NS|PTR|SOA|SRV|TXT|WKS,
      #         --query                      Queries a specific type of DNS record
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [HOST ...]                       The host name(s) to query
      #
      class Host < ValueProcessorCommand

        include DNS

        usage '[options] [HOST ...]'

        option :subdomain, value: {
                             type:  String,
                             usage: 'SUBNAME'
                           },
                           desc: 'Converts the hostname to a sub-domain'

        option :domain, short: '-d',
                        desc:  'Converts the hostname to a domain'

        option :tld, short: '-T',
                     desc: "Converts the hostname to it's TLD"

        option :suffix, short: '-s',
                        desc: "Converts the hostname to it's suffix"

        option :change_suffix, short: '-S',
                               value: {
                                 type:  String,
                                 usage: 'SUFFIX'
                               },
                               desc: 'Changes the suffix of each hostname'

        option :enum_tlds, desc: 'Enumerates over every TLD'

        option :enum_suffixes, equals: true,
                               value: {
                                 type:     [:icann, :private],
                                 required: false
                               },
                               desc: 'Enumerates over every domain suffix'

        option :enum_subdomains, value: {
                                   type:  String,
                                   usage: 'FILE'
                                 },
                                 desc: 'Enumerates over every subdomain in the wordlist'

        option :ips, short: '-I',
                     desc:  "Converts the hostname to it's IP addresses"

        option :registered, short: '-r',
                            desc: 'Filters hostnames that are registered'

        option :unregistered, short: '-u',
                              desc: 'Filters hostnames that are unregistered'

        option :has_addresses, short: '-A',
                               desc:  'Filters hostnames that have addresses'

        option :has_records, short: '-H',
                             value: {
                               type: {
                                 A: :a,
                                 AAAA: :aaaa,
                                 ANY: :any,
                                 CNAME: :cname,
                                 HINFO: :hinfo,
                                 LOC: :loc,
                                 MINFO: :minfo,
                                 MX: :mx,
                                 NS: :ns,
                                 PTR: :ptr,
                                 SOA: :soa,
                                 SRV: :srv,
                                 TXT: :txt,
                                 WKS: :wks
                               }
                             },
                             desc: 'Filters hostnames that have a certain DNS record type'

        option :query, short: '-t',
                       value: {
                         type: [:A, :AAAA, :ANY, :CNAME, :HINFO, :LOC, :MINFO, :MX, :NS, :PTR, :SOA, :SRV, :TXT, :WKS]
                       },
                       desc: 'Queries a specific type of DNS record'

        argument :host, required: false,
                        repeats:  true,
                        desc:     'The host name(s) to query'

        description 'Processes hostname(s)'

        man_page 'ronin-host.1'

        #
        # Queries the given host.
        #
        # @param [String] host
        #
        def process_value(host)
          host = Support::Network::Host.new(host)

          if options[:change_suffix]
            process_host(host.change_suffix(options[:change_suffix]))
          elsif options[:enum_tlds]
            host.each_tld(&method(:process_hostname))
          elsif options.has_key?(:enum_suffixes)
            host.each_suffix(
              type: options[:enum_suffixes], &method(:process_hostname)
            )
          elsif options[:enum_subdomains]
            path = options[:enum_subdomains]

            unless File.file?(path)
              print_error "wordlist file not found: #{path.inspect}"
              exit(-1)
            end

            Wordlist::File.open(path) do |wordlist|
              wordlist.each do |subname|
                process_hostname(host.subdomain(subname))
              end
            end
          else
            process_hostname(host)
          end
        end

        #
        # Processes a single hostname.
        #
        # @param [Ronin::Support::Network::Host] host
        #   The host object to process.
        #
        def process_hostname(host)
          if options[:subdomain]
            puts host.subdomain(options[:subdomain])
          elsif options[:domain]
            puts host.domain
          elsif options[:tld]
            puts host.tld
          elsif options[:suffix]
            puts host.suffix
          elsif options[:ips]
            puts host.get_addresses
          elsif options[:registered]
            puts host if host.registered?
          elsif options[:unregistered]
            puts host if host.unregistered?
          elsif options[:has_addresses]
            puts host if host.has_addresses?
          elsif options[:has_records]
            puts host unless host.get_records(options[:has_records]).empty?
          elsif options[:query]
            print_records(query_records(host))
          else
            puts host.name
          end
        end

      end
    end
  end
end

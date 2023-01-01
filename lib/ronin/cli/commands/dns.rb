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

        usage '[options] HOST'

        option :nameserver, short: '-N',
                            value: {
                              type: String,
                              usage: 'HOST|IP'
                            },
                            desc: 'Send DNS queries to the nameserver' do |ip|
                              @nameservers << ip
                            end

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
        # Initializes the `ronin dns` command.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @nameservers = []
        end

        #
        # The resolver to use.
        #
        # @return [Ronin::Network::DNS::Resolver]
        #   The DNS resolver.
        #
        def resolver
          @resolver ||= unless @nameservers.empty?
                          Support::Network::DNS.resolver(nameservers: @nameservers)
                        else
                          Support::Network::DNS.resolver
                        end
        end

        #
        # Queries the given host.
        #
        # @param [String] host
        #
        def process_value(host)
          print_records(query_records(host))
        end

        #
        # Queries the records for the given host name.
        #
        # @param [String] host
        #   The host name to query.
        #
        # @return [Array<Resolv::DNS::Resource>]
        #   The returned DNS resource records.
        #
        def query_records(host)
          if options[:type]
            resolver.get_records(host,options[:type].downcase)
          else
            resolver.get_a_records(host) + resolver.get_aaaa_records(host)
          end
        end

        #
        # Prints multiple DNS records.
        #
        # @param [Array<Resolv::DNS::Resource>] records
        #   The DNS resource records to print.
        #
        def print_records(records)
          records.each do |record|
            print_record(record)
          end
        end

        #
        # Prints a DNS record.
        #
        # @param [Resolv::DNS::Resource] record
        #   The DNS resource record to print.
        #
        def print_record(record)
          case record
          when Resolv::DNS::Resource::IN::A,
               Resolv::DNS::Resource::IN::AAAA
            puts record.address
          when Resolv::DNS::Resource::IN::NS,
               Resolv::DNS::Resource::IN::CNAME,
               Resolv::DNS::Resource::IN::PTR
            puts record.name
          when Resolv::DNS::Resource::IN::MX
            puts record.exchange
          when Resolv::DNS::Resource::IN::TXT
            puts record.strings.join
          when Resolv::DNS::Resource::IN::HINFO
            puts "#{record.cpu} #{record.os}"
          when Resolv::DNS::Resource::IN::LOC
            puts "#{record.latitude} #{record.longitude}"
          when Resolv::DNS::Resource::IN::MINFO
            puts "#{record.emailbx}@#{record.rmailbx}"
          when Resolv::DNS::Resource::IN::SOA
            puts "#{record.mname} #{record.rname} #{record.serial} #{record.refresh} #{record.retry} #{record.expire} #{record.ttl}"
          when Resolv::DNS::Resource::IN::SRV
            puts "#{record.port} #{record.priority} #{record.weight} #{record.target}"
          when Resolv::DNS::Resource::IN::WKS
            puts "#{record.address} #{record.protocol}"
          end
        end

      end
    end
  end
end

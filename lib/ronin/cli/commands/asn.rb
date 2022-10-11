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
require 'ronin/support/network/asn'
require 'ronin/support/network/asn/list'

require 'command_kit/options/verbose'

module Ronin
  class CLI
    module Commands
      #
      # Queries or searches for ASN information.
      #
      # ## Usage
      #
      #     ronin asn [options] [-v | --enum-ips] {-n,--number NUM | -c,--country COUNTRY | -N,--name NAME | -I,--ip IP}
      #
      # ## Options
      #
      #     -v, --verbose                    Enables verbose output
      #     -U, --url URI                    Overrides the default ASN list URL (Default: https://iptoasn.com/data/ip2asn-combined.tsv.gz)
      #     -f, --file FILE                  Overrides the default ASN list file (Default: /home/postmodern/.local/share/ronin/ronin-support/ip2asn-combined.tsv.gz)
      #     -u, --update                     Updates the ASN list file
      #     -n, --number INT                 Searches for all ASN records with the AS number
      #     -C XX|None|Uknown,               Searches for all ASN records with the country code
      #         --country-code
      #     -N, --name NAME                  Searches for all ASN records with the matching name
      #     -I, --ip IP                      Queries the ASN record for the IP
      #     -4, --ipv4                       Filter ASN records for only IPv4 ranges
      #     -6, --ipv6                       Filter ASN records for only IPv6 ranges
      #     -E, --enum-ips                   Enumerate over the IPs within the ASN ranges
      #     -h, --help                       Print help information
      #
      # ## Examples
      #
      #     ronin asn -v -n 15133
      #     ronin asn -v -I 93.184.216.34
      #     ronin asn -C US
      #     ronin asn -N EDGECAST
      #     ronin asn --enum-ips -n 15133
      #     ronin asn --enum-ips -N EDGECAST
      #
      class Asn < Command

        include CommandKit::Options::Verbose
        include Core::CLI::Logging

        usage '[options] [-v | --enum-ips] {-n,--number NUM | -c,--country COUNTRY | -N,--name NAME | -I,--ip IP}'

        option :url, short: '-U',
                     value: {
                       type:    String,
                       usage:   'URI',
                       default: Support::Network::ASN::List::URL
                     },
                     desc: 'Overrides the default ASN list URL'

        option :file, short: '-f',
                      value: {
                        type:    String,
                        usage:   'FILE',
                        default: Support::Network::ASN::List::PATH
                      },
                      desc: 'Overrides the default ASN list file'

        option :update, short: '-u',
                        desc: 'Updates the ASN list file'

        option :number, short: '-n',
                        value: {
                          type: Integer,
                        },
                        desc: 'Searches for all ASN records with the AS number'

        option :country_code, short: '-C',
                              value: {
                                type:  /[A-Z]{2}|None|Unknown/,
                                usage: 'XX|None|Uknown'
                              },
                              desc: 'Searches for all ASN records with the country code'

        option :name, short: '-N',
                      value: {
                        type:  String,
                        usage: 'NAME'
                      },
                      desc: 'Searches for all ASN records with the matching name'

        option :ip, short: '-I',
                    value: {
                      type:  String,
                      usage: 'IP'
                    },
                    desc: 'Queries the ASN record for the IP'

        option :ipv4, short: '-4',
                    desc: 'Filter ASN records for only IPv4 ranges'

        option :ipv6, short: '-6',
                    desc: 'Filter ASN records for only IPv6 ranges'

        option :enum_ips, short: '-E',
                          desc:  'Enumerate over the IPs within the ASN ranges'

        description 'Queries or searches for ASN information'

        examples [
          '-v -n 15133',
          '-v -I 93.184.216.34',
          '-C US',
          '-N EDGECAST',
          '--enum-ips -n 15133',
          '--enum-ips -N EDGECAST'
        ]

        man_page 'ronin-asn.1'

        #
        # Runs the `ronin asn` command.
        #
        def run
          if !File.file?(options[:file])
            download
          elsif options[:update] || stale?
            update
          end

          if options[:ip]
            if (record = query_ip(options[:ip]))
              print_asn_record(record)
            else
              print_error "could not find a record for the IP: #{options[:ip]}"
              exit -1
            end
          else
            print_asn_records(search_asn_records)
          end
        end

        #
        # Determines if the ASN list file is stale.
        #
        def stale?
          Support::Network::ASN::List.stale?(options[:file])
        end

        #
        # Downloads the ASN list file.
        #
        def download
          if verbose?
            log_info "Downloading ASN list from #{options[:url]} to #{options[:file]} ..."
          end

          Support::Network::ASN::List.download(
            url:  options[:url],
            path: options[:file]
          )
        end

        #
        # Updates the ASN list file.
        #
        def update
          if verbose?
            log_info "Updating ASN list file #{options[:file]} ..."
          end

          Support::Network::ASN::List.update(path: options[:file])
        end

        #
        # Parses the ASN list file.
        #
        # @yield [record]
        #
        # @yieldparam [Ronin::Support::Network::ASN::Record] record
        #
        # @return [Enumerator]
        #
        def list_file(&block)
          Support::Network::ASN::List.parse(options[:file],&block)
        end

        #
        # Queries the ASN record for the given IP address.
        #
        # @param [String] ip
        #
        # @return [Ronin::Support::Network::ASN::DNSRecord]
        #
        def query_ip(ip)
          Support::Network::ASN.query(ip)
        end

        #
        # Queries ASN records.
        #
        # @return [Ronin::Support::Network::ASN::RecordSet]
        #
        def search_asn_records
          records = Support::Network::ASN::RecordSet.new(list_file)

          if    options[:ipv4]  then records = records.ipv4
          elsif options[:ipv6]  then records = records.ipv6
          end

          if options[:country_code]
            records = records.country(options[:country_code])
          end

          if options[:number]
            records = records.number(options[:number])
          end

          if options[:name]
            records = records.name(options[:name])
          end

          return records
        end

        #
        # Prints a collection of ASN records.
        #
        # @param [Ronin::Support::Network::ASN::RecordSet] records
        #
        def print_asn_records(records)
          records.each do |record|
            print_asn_record(record)
          end
        end

        #
        # Prints an ASN record.
        #
        # @param [Ronin::Support::Network::ASN::Record] record
        #
        def print_asn_record(record)
          if options[:enum_ips]
            record.range.each do |ip|
              puts ip
            end
          elsif options[:verbose]
            puts "[ AS#{record.number} ]"
            puts
            puts "ASN:      #{record.number}"
            puts "IP range: #{record.range}"
            puts "Country:  #{record.country_code}"
            puts "Name:     #{record.name}"
            puts
          else
            puts record
          end
        end

      end
    end
  end
end

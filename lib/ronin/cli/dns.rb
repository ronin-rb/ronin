# frozen_string_literal: true
#
# Copyright (c) 2006-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/support/network/dns'

module Ronin
  class CLI
    #
    # Mixin for adding DNS support to commands.
    #
    module DNS
      # Mapping of DNS record types and lowercase versions.
      RECORD_TYPES = {
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

      #
      # Adds the `-N,--nameserver HOST|IP` option to the command which is
      # including {DNS}.
      #
      # @param [Class<Command>] command
      #   The command which is including {DNS}.
      #
      def self.included(command)
        command.option :nameserver, short: '-N',
                                    value: {
                                      type: String,
                                      usage: 'HOST|IP'
                                    },
                                    desc: 'Send DNS queries to the nameserver' do |ip|
                                      @nameservers << ip
                                    end
      end

      # The configured nameservers to query.
      #
      # @return [Array<String>]
      attr_reader :nameservers

      #
      # Initializes the command.
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
                        Support::Network::DNS.resolver(
                          nameservers: @nameservers
                        )
                      else
                        Support::Network::DNS.resolver
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

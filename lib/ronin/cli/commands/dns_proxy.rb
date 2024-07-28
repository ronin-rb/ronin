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

require_relative '../command'
require 'ronin/core/cli/logging'
require 'ronin/dns/proxy'

module Ronin
  class CLI
    module Commands
      #
      # Starts a DNS proxy.
      #
      # ## Usage
      #
      #     ronin dns-proxy [options] [HOST] PORT
      #
      # ## Options
      #
      #     -n, --nameserver IP              The upstream nameserver IP to use
      #     -r RECORD_TYPE:NAME:RESULT|RECORD_TYPE:/REGEXP/:RESULT,
      #         --rule                       Adds a rule to the DNS proxy
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [HOST]                           The host name to listen on.
      #     PORT                             The port number to listen on.
      #
      # @since 2.1.0
      #
      class DnsProxy < Command

        include Core::CLI::Logging

        usage '[options] [HOST] PORT'

        option :nameserver, short: '-n',
                            value: {
                              type:  String,
                              usage: 'IP'
                            },
                            desc: 'The upstream nameserver IP to use' do |ip|
                              @nameservers << ip
                            end

        option :rule, short: '-r',
                      value: {
                        type:  %r{\A[^:]+:(?:[^:]+|/[^/:]+/):.+\z},
                        usage: 'RECORD_TYPE:NAME:RESULT|RECORD_TYPE:/REGEXP/:RESULT'
                      },
                      desc: 'Adds a rule to the DNS proxy' do |rule|
                        @rules << parse_rule(rule)
                      end

        argument :host, required: false,
                        desc:    'The host to listen on'

        argument :port, required: true,
                        desc:     'The port number to listen on'

        description 'Starts a DNS proxy'

        man_page 'ronin-dns-proxy.1'

        # The upstream nameserver IP addresses to forward DNS queries to.
        #
        # @return [Array<String>]
        attr_reader :nameservers

        # The rules for the DNS proxy server.
        #
        # @return [Array<(Symbol, String, String), (Symbol, Regexp, String)>]
        attr_reader :rules

        #
        # Initializes the `ronin dns-proxy` command.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for the command.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @nameservers = []
          @rules       = []
        end

        #
        # Runs the `ronin dns-proxy` command.
        #
        def run(host='127.0.0.1',port)
          port = port.to_i

          log_info "Listening on #{host}:#{port} ..."
          DNS::Proxy.run(host,port,**proxy_kwargs)
        end

        #
        # The keyword arguments for `Ronin::DNS::Proxy.run`.
        #
        # @return [Hash{Symbol => Object}]
        #
        def proxy_kwargs
          kwargs = {rules: @rules}

          unless @nameservers.empty?
            kwargs[:nameservers] = @nameservers
          end

          return kwargs
        end

        # Record types.
        RECORD_TYPES = {
          'A'     => :A,
          'AAAA'  => :AAAA,
          'ANY'   => :ANY,
          'CNAME' => :CNAME,
          'HINFO' => :HINFO,
          'LOC'   => :LOC,
          'MINFO' => :MINFO,
          'MX'    => :MX,
          'NS'    => :NS,
          'PTR'   => :PTR,
          'SOA'   => :SOA,
          'SRV'   => :SRV,
          'TXT'   => :TXT,
          'WKS'   => :WKS
        }

        #
        # Parses a record type name.
        #
        # @param [String] record_type
        #   The record type to parse.
        #
        # @return [:A, :AAAA, :ANY, :CNAME, :HINFO, :LOC, :MINFO, :MX, :NS, :PTR, :SOA, :SRV, :TXT, :WKS]
        #   The parsed record type.
        #
        # @raise [OptionParser::InvalidArgument]
        #   The record type was unknown.
        #
        def parse_record_type(record_type)
          RECORD_TYPES.fetch(record_type) do
            raise(OptionParser::InvalidArgument,"invalid record type: #{record_type.inspect}")
          end
        end

        #
        # Parses the name field of a record.
        #
        # @param [String] name
        #   The name field to parse.
        #
        # @return [String, Regex]
        #   The parsed name. If the name field starts with a `/` and ends with a
        #   `/`, then a Regexp will be returned.
        #
        # @raise [OptionParser::InvalidArgument]
        #   The name field regex could not be parsed.
        #
        def parse_record_name(name)
          if name.start_with?('/') && name.end_with?('/')
            begin
              Regexp.new(name[1..-2])
            rescue RegexpError => error
              raise(OptionParser::InvalidArgument,"invalid Regexp: #{error.message}")
            end
          else
            name
          end
        end

        # Error names.
        ERROR_CODES = {
          'NoError'  => :NoError,
          'FormErr'  => :FormErr,
          'ServFail' => :ServFail,
          'NXDomain' => :NXDomain,
          'NotImp'   => :NotImp,
          'Refused'  => :Refused,
          'NotAuth'  => :NotAuth
        }

        #
        # Parses a result value.
        #
        # @param [String] result
        #   A result value to parse.
        #
        # @return [String, :NoError, :FormErr, :ServFail, :NXDomain, :NotImp, :Refused, :NotAuth]
        #   The parsed result value or a DNS error code.
        #
        def parse_rule_result(result)
          ERROR_CODES.fetch(result,result)
        end

        #
        # Parses a rule string.
        #
        # @param [String] rule
        #   The string to parse.
        #
        # @return [(Symbol, String, String), (Symbol, Regexp, String)]
        #   The parsed rule.
        #
        # @raise [OptionParser::InvalidArgument]
        #   The rule string could not be parsed.
        #
        def parse_rule(rule)
          record_type, name, result = rule.split(':',3)

          [
            parse_record_type(record_type),
            parse_record_name(name),
            parse_rule_result(result)
          ]
        end

      end
    end
  end
end

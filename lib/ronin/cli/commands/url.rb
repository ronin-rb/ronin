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

require_relative '../value_processor_command'

require 'uri'
require 'uri/query_params'
require 'ronin/support/network/url'

module Ronin
  class CLI
    module Commands
      #
      # Parses URL(s).
      #
      # ## Usage
      #
      #     ronin url [options] [URL ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to read values from
      #     -u, --user                       Print the URL's user name
      #         --password                   Print the URL's password
      #         --user-password              Print the URL's user name and password
      #     -H, --host                       Print the URL's host name
      #         --port                       Print the URL's port
      #         --host-port                  Print the URL's host:port
      #     -P, --path                       Print the URL's path
      #         --path-query                 Print the URL's path and query string
      #     -Q, --query                      Print the URL's query string
      #     -q, --query-param NAME           Print the query param from the URL's query string
      #     -F, --fragment                   Print the URL's fragment
      #     -S, --status                     Print the HTTP status of each URL
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [URL ...]                        The URL(s) to parse
      #
      # ## Examples
      #
      #     ronin url --host https://example.com/foo
      #     ronin url --host-port https://example.com:8080/foo
      #     ronin url --param id https://example.com/page?id=100
      #
      class Url < ValueProcessorCommand

        usage '[options] [URL ...]'

        option :user, short: '-u',
                      desc:  "Print the URL's user name"

        option :password, desc: "Print the URL's password"

        option :user_password, desc: "Print the URL's user name and password"

        option :host, short: '-H',
                      desc:  "Print the URL's host name"

        option :port, desc: "Print the URL's port"

        option :host_port, desc: "Print the URL's host:port"

        option :path, short: '-P',
                      desc:  "Print the URL's path"

        option :path_query, desc: "Print the URL's path and query string"

        option :query, short: '-Q',
                       desc:  "Print the URL's query string"

        option :query_param, short: '-q',
                             value: {
                               type:  String,
                               usage: 'NAME'
                             },
                             desc: "Print the query param from the URL's query string"

        option :fragment, short: '-F',
                          desc:  "Print the URL's fragment"

        option :status, short: '-S',
                        desc:  'Print the HTTP status of each URL'

        argument :url, required: false,
                       repeats:  true,
                       desc:     'The URL(s) to parse'

        examples [
          "--host https://example.com/foo",
          "--host-port https://example.com:8080/foo",
          "--param id https://example.com/page?id=100"
        ]

        description 'Parses URLs'

        man_page 'ronin-url.1'

        #
        # Processes an individual URL.
        #
        # @param [String] url
        #
        def process_value(url)
          url = Support::Network::URL.parse(url)

          if options[:user]
            puts url.user
          elsif options[:password]
            puts url.password
          elsif options[:user_password]
            puts "#{url.user}:#{url.password}"
          elsif options[:host]
            puts url.host
          elsif options[:host_port]
            puts "#{url.host}:#{url.port}"
          elsif options[:path]
            puts url.path
          elsif options[:query]
            puts url.query
          elsif options[:path_query]
            puts url.request_uri
          elsif options[:param]
            puts url.query_params[options[:param]]
          elsif options[:fragment]
            puts url.fragment
          elsif options[:status]
            begin
              puts "#{url.status} #{url}"
            rescue StandardError => error
              print_error "#{url}: #{error.message}"
            end
          else
            puts url
          end
        end

      end
    end
  end
end

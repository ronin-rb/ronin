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
require 'ronin/cli/printing/http'
require 'ronin/cli/http_shell'
require 'ronin/support/network/http'

require 'command_kit/options/verbose'
require 'command_kit/options/output'

require 'rouge'

module Ronin
  class CLI
    module Commands
      #
      # A HTTP command and shell.
      #
      # ## Usage
      #
      #     ronin http [options] [URL [...] | --shell URL]
      #
      # ## Options
      #
      #     -v, --verbose                    Enables verbose output
      #     -f, --file FILE                  Optional file to read values from
      #     -o, --output FILE                Optional output file
      #         --method HTTP_METHOD         Send the HTTP request method
      #         --get                        Send a GET request
      #         --head                       Send a HEAD request
      #         --patch                      Send a PATCH request
      #         --post                       Send a POST request
      #         --put                        Send a PUT request
      #         --copy                       Send a COPY request
      #         --delete                     Send a DELETE request
      #         --lock                       Send a LOCK request
      #         --options                    Send a OPTIONS request
      #         --mkcol                      Send a MKCOL request
      #         --move                       Send a MOVE request
      #         --propfind                   Send a PROPFIND request
      #         --proppatch                  Send a PROPPATCH request
      #         --trace                      Send a TRACE request
      #         --unlock                     Send an UNLOCK request
      #         --shell URL                  Open an interactive HTTP shell
      #     -P, --proxy URL                  The proxy to use
      #     -U, --user-agent-string STRING   The User-Agent string to use
      #     -u chrome_linux|chrome_macos|chrome_windows|chrome_iphone|chrome_ipad|chrome_android|firefox_linux|firefox_macos|firefox_windows|firefox_iphone|firefox_ipad|firefox_android|safari_macos|safari_iphone|safari_ipad|edge,
      #         --user-agent                 The User-Agent to use
      #     -H, --header NAME=VALUE          Adds a header to the request
      #     -B, --body STRING                The request body
      #     -F, --body-file FILE             Sends the file as the request body
      #     -f, --form-data NAME=VALUE       Adds a value to the form data
      #     -q, --query-param NAME=VALUE     Adds a query param to the URL
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [URL ...]                        The URL(s) to request
      #
      class Http < ValueProcessorCommand

        include CommandKit::Options::Verbose
        include CommandKit::Options::Output
        include Printing::HTTP

        usage '[options] {URL [...] | --shell URL}'

        option :method, value: {
                          type: {
                            'COPY'      => :copy,
                            'DELETE'    => :delete,
                            'GET'       => :get,
                            'HEAD'      => :head,
                            'LOCK'      => :lock,
                            'MKCOL'     => :mkcol,
                            'MOVE'      => :move,
                            'OPTIONS'   => :options,
                            'PATCH'     => :patch,
                            'POST'      => :post,
                            'PROPFIND'  => :propfind,
                            'PROPPATCH' => :proppatch,
                            'PUT'       => :put,
                            'TRACE'     => :trace,
                            'UNLOCK'    => :unlock
                          },
                          usage: 'HTTP_METHOD'
                        },
                        desc: 'Send the HTTP request method' do |name|
                          @http_method = name
                        end

        option :get, desc: 'Send a GET request' do
          @http_method = :get
        end
        option :head, desc: 'Send a HEAD request' do
          @http_method = :head
        end
        option :patch, desc: 'Send a PATCH request' do
          @http_method = :patch
        end
        option :post, desc: 'Send a POST request' do
          @http_method = :post
        end
        option :put, desc: 'Send a PUT request' do
          @http_method = :put
        end
        option :copy, desc: 'Send a COPY request' do
          @http_method = :copy
        end
        option :delete, desc: 'Send a DELETE request' do
          @http_method = :delete
        end
        option :lock, desc: 'Send a LOCK request' do
          @http_method = :lock
        end
        option :options, desc: 'Send a OPTIONS request' do
          @http_method = :options
        end
        option :mkcol, desc: 'Send a MKCOL request' do
          @http_method = :mkcol
        end
        option :move, desc: 'Send a MOVE request' do
          @http_method = :move
        end
        option :propfind, desc: 'Send a PROPFIND request' do
          @http_method = :propfind
        end
        option :proppatch, desc: 'Send a PROPPATCH request' do
          @http_method = :proppatch
        end
        option :trace, desc: 'Send a TRACE request' do
          @http_method = :trace
        end
        option :unlock, desc: 'Send an UNLOCK request' do
          @http_method = :unlock
        end

        option :shell, value: {
                         type:  String,
                         usage: 'URL'
                       },
                       desc: 'Open an interactive HTTP shell'

        option :proxy, short: '-P',
                       value: {
                         type:   String,
                         usage: 'URL'
                       },
                       desc: 'The proxy to use' do |proxy|
                         @proxy = URI.parse(proxy)
                       end

        option :user_agent_string, short: '-U',
                                   value: {
                                     type: String,
                                     usage: 'STRING'
                                   },
                                   desc: 'The User-Agent string to use' do |ua|
                                     @user_agent = ua
                                   end

        option :user_agent, short: '-u',
                            value: {
                              type: Support::Network::HTTP::USER_AGENTS.keys
                            },
                            desc: 'The User-Agent to use' do |name|
                              @user_agent = name
                            end

        option :header, short: '-H',
                        value: {
                          type:  /[^=]+=.+/,
                          usage: 'NAME=VALUE'
                        },
                        desc: 'Adds a header to the request' do |str|
                          name, value = str.split('=',2)

                          @headers[name] = value
                        end

        option :body, short: '-B',
                      value: {
                        type:  String,
                        usage: 'STRING'
                      },
                      desc: 'The request body' do |str|
                        @body = str
                      end

        option :body_file, short: '-F',
                           value: {
                             type:  String,
                             usage: 'FILE'
                           },
                           desc: 'Sends the file as the request body' do |path|
                             @body = File.new(path)
                           end

        option :form_data, short: '-f',
                           value: {
                             type:  /[^=]+=.*/,
                             usage: 'NAME=VALUE'
                           },
                           desc: 'Adds a value to the form data' do |str|
                             name, value = str.split('=',2)

                             @form_data[name] = value
                           end

        option :query_param, short: '-q',
                             value: {
                               type:  /[^=]+=.*/,
                               usage: 'NAME=VALUE'
                             },
                             desc: 'Adds a query param to the URL' do |str|
                               name, value = str.split('=',2)

                               @query_params[name] = value
                             end

        argument :url, required: false,
                       repeats:  true,
                       desc:     'The URL(s) to request'

        # The optional proxy to use.
        #
        # @return [URI::HTTP, nil]
        attr_reader :proxy

        # The HTTP request method.
        #
        # @return [Symbol]
        attr_reader :http_method

        # Additional HTTP request headers to send.
        #
        # @return [Hash{String => String}]
        attr_reader :headers

        # Optional `User-agent` string to use.
        #
        # @return [String, nil]
        attr_reader :user_agent

        # Additional URL query params.
        #
        # @return [Hash{String => String}]
        attr_reader :query_params

        # Form data.
        #
        # @return [Hash{String => String}]
        attr_reader :form_data

        #
        # Initializes the `ronin http` command.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @proxy        = nil
          @http_method  = :get
          @headers      = {}
          @user_agent   = nil
          @query_params = {}
          @form_data    = {}
        end

        #
        # Runs the `ronin http` command.
        #
        # @param [Array<String>] urls
        #   The URL(s) to request.
        #
        def run(*urls)
          if options[:shell]
            start_shell(options[:shell])
          else
            super(*urls)
          end
        end

        #
        # Start the {HTTPShell}.
        #
        # @param [String] base_url
        #   The base URL to connect to.
        #
        def start_shell(base_url)
          HTTPShell.start(base_url, proxy:      @proxy,
                                    headers:    @headers,
                                    user_agent: @user_agent)
        end

        #
        # Requests the given URL.
        #
        # @param [String] url
        #   The URL to request.
        #
        def process_value(url)
          url = URI(url)

          Support::Network::HTTP.connect_uri(url, proxy:      @proxy,
                                                  user_agent: @user_agent) do |http|
            http.request(
              @http_method, url.request_uri, user:         url.user,
                                             password:     url.password,
                                             query_params: @query_params,
                                             headers:      @headers,
                                             body:         @body,
                                             form_data:    @form_data,
                                             &method(:print_response))
          end
        end

        #
        # Prints the HTTP response.
        #
        # @param [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @note
        #   If `--verbose` is specified then the response headers will also be
        #   printed.
        #
        # @see HTTPMethods#print_response
        #
        def print_response(response)
          super(response, show_headers: options[:verbose])
        end

      end
    end
  end
end

#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
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
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/network/http'
require 'ronin/ui/output/helpers'
require 'ronin/mixin'

require 'parameters'

module Ronin
  module Network
    module Mixins
      #
      # Adds HTTP convenience methods and connection parameters to a class.
      #
      module HTTP
        include Mixin

        mixin UI::Output::Helpers, Parameters

        mixin do
          # HTTP host
          parameter :host, :type => String,
                           :description => 'HTTP host'

          # HTTP port
          parameter :port, :default => Net::HTTP.default_port,
                           :description => 'HTTP port'

          # HTTP `Host` header to send
          parameter :http_vhost, :type => String,
                                 :description => 'HTTP Host header to send'

          # HTTP user to authenticate as
          parameter :http_user, :type => String,
                                :description => 'HTTP user to authenticate as'

          # HTTP password to authenticate with
          parameter :http_password, :type => String,
                                    :description => 'HTTP password to authenticate with'

          # HTTP proxy information
          parameter :http_proxy, :description => 'HTTP proxy information'

          # HTTP `User-Agent` header to send
          parameter :http_user_agent, :type => String,
                                      :description => 'HTTP User-Agent header to send'
        end

        protected

        #
        # Resets the HTTP proxy settings.
        #
        def disable_http_proxy
          @http_proxy = nil
        end

        #
        # Connects to the HTTP server.
        #
        # @param [Hash] options
        #   Additional options
        #
        # @option options [String, URI::HTTP] :url
        #   The full URL to request.
        #
        # @option options [String] :user
        #   The user to authenticate with when connecting to the HTTP
        #   server.
        #
        # @option options [String] :password
        #   The password to authenticate with when connecting to the HTTP
        #   server.
        #
        # @option options [String] :host
        #   The host the HTTP server is running on.
        #
        # @option options [Integer] :port (Net::HTTP.default_port)
        #   The port the HTTP server is listening on.
        #
        # @option options [String] :path
        #   The path to request from the HTTP server.
        #
        # @yield [session]
        #   If a block is given, it will be passes the new HTTP session
        #   object.
        #
        # @yieldparam [Net::HTTP] session
        #   The newly created HTTP session.
        #
        # @return [Net::HTTP]
        #   The HTTP session object.
        #
        def http_session(options={})
          options = http_merge_options(options)
          host_port = "#{options[:host]}:#{options[:port]}"

          Net.http_session(options) do |http|
            print_info "Starting HTTP Session with #{host_port}"

            yield http

            print_info "Closing HTTP Session with #{host_port}"
          end
        end

        #
        # Connects to the HTTP server and sends an HTTP Request.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Hash{String,Symbol => Object}] :headers
        #   The Hash of the HTTP headers to send with the request.
        #   May contain either Strings or Symbols, lower-case or
        #   camel-case keys.
        #
        # @yield [request, (options)]
        #   If a block is given, it will be passed the HTTP request object.
        #   If the block has an arity of 2, it will also be passed the
        #   expanded version of the given options.
        #
        # @yieldparam [Net::HTTP::Request] request
        #   The HTTP request object to use in the request.
        #
        # @yieldparam [Hash] options
        #   The expanded version of the given options.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_session
        #
        def http_request(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP #{options[:method]} #{http_options_to_s(options)}"

          return Net.http_request(options,&block)
        end

        #
        # Performs an HTTP Copy request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_copy(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP COPY #{http_options_to_s(options)}"

          return Net.http_copy(options,&block)
        end

        #
        # Performs an HTTP Delete request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_delete(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP DELETE #{http_options_to_s(options)}"

          return Net.http_delete(options,&block)
        end

        #
        # Performs an HTTP Get request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_get(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP GET #{http_options_to_s(options)}"

          return Net.http_get(options,&block)
        end

        #
        # Performs an HTTP Get request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [String]
        #   The body of the HTTP Get request.
        #
        # @see http_get
        #
        def http_get_body(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP GET #{http_options_to_s(options)}"

          return Net.http_get_body(options,&block)
        end

        #
        # Performs an HTTP Head request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_head(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP HEAD #{http_options_to_s(options)}"

          return Net.http_head(options,&block)
        end

        #
        # Performs an HTTP Lock request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_lock(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP LOCK #{http_options_to_s(options)}"

          return Net.http_lock(options,&block)
        end

        #
        # Performs an HTTP Mkcol request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_mkcol(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP MKCOL #{http_options_to_s(options)}"

          return Net.http_mkcol(options,&block)
        end

        #
        # Performs an HTTP Move request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_move(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP MOVE #{http_options_to_s(options)}"

          return Net.http_move(options,&block)
        end

        #
        # Performs an HTTP Options request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_options(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP OPTIONS #{http_options_to_s(options)}"

          return Net.http_options(options,&block)
        end

        #
        # Performs an HTTP Post request.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [String] :post_data
        #   The `POSTDATA` to send with the HTTP Post request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_post(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP POST #{http_options_to_s(options)}"

          return Net.http_post(options,&block)
        end

        #
        # Performs an HTTP Post request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [String]
        #   The body of the Post request.
        #
        # @see http_post
        #
        def http_post_body(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP POST #{http_options_to_s(options)}"

          return Net.http_post_body(options,&block)
        end

        #
        # Performs an HTTP Propfind request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_prop_find(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP PROPFIND #{http_options_to_s(options)}"

          return Net.http_prop_find(options,&block)
        end

        #
        # Performs an HTTP Proppatch request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_prop_patch(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP PROPPATCH #{http_options_to_s(options)}"

          return Net.http_prop_patch(options,&block)
        end

        #
        # Performs an HTTP Trace request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_trace(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP TRACE #{http_options_to_s(options)}"

          return Net.http_trace(options,&block)
        end

        #
        # Performs an HTTP Unlock request.
        #
        # @yield [response]
        #   If a block is given, it will be passed the response received
        #   from the request.
        #
        # @yieldparam [Net::HTTP::Response] response
        #   The HTTP response object.
        #
        # @return [Net::HTTP::Response]
        #   The response of the HTTP request.
        #
        # @see http_request
        #
        def http_unlock(options={},&block)
          options = http_merge_options(options)
          print_info "HTTP UNLOCK #{http_options_to_s(options)}"

          return Net.http_unlock(options,&block)
        end

        private

        #
        # Merges the http parameters into the HTTP options.
        #
        # @param [Hash] options
        #   The HTTP options to merge into.
        #
        # @return [Hash]
        #   The merged HTTP options.
        #
        # @since 1.0.0
        #
        def http_merge_options(options={})
          options[:host] ||= self.host if self.host
          options[:port] ||= self.port if self.port

          if (self.http_vhost || self.http_user_agent)
            headers = options.fetch(:headers,{})

            headers[:host] ||= self.http_vhost if self.http_vhost
            headers[:user_agent] ||= self.http_user_agent if self.http_user_agent

            options[:headers] = headers
          end

          options[:user] ||= self.http_user if self.http_user
          options[:password] ||= self.http_password if self.http_password

          options[:proxy] ||= self.http_proxy if self.http_proxy

          return options
        end

        #
        # Converts the HTTP options to a printable String.
        #
        # @param [Hash] options
        #   HTTP options.
        #
        # @return [String]
        #   The printable String.
        #
        # @since 1.1.0
        #
        def http_options_to_s(options)
          fields = ["#{options[:host]}:#{options[:port]}"]

          if (options[:user] || options[:password])
            fields << "#{options[:user]}:#{options[:password]}"
          end

          path = options[:path]
          path += "?#{options[:query]}" if options[:query]

          fields << path

          if options[:headers]
            fields << ("%p" % options[:headers])
          end

          return fields.join(' ')
        end

      end
    end
  end
end

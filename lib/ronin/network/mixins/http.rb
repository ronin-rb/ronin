#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA  02110-1301  USA
#

require 'ronin/network/http'

require 'parameters'

module Ronin
  module Network
    module Mixins
      #
      # Adds HTTP convenience methods and connection parameters to a class.
      #
      module HTTP
        include Parameters

        # HTTP host
        parameter :host,
                  :type => String,
                  :description => 'HTTP host'

        # HTTP port
        parameter :port,
                  :type => Integer,
                  :description => 'HTTP port'

        # HTTP `Host` header to send
        parameter :http_vhost,
                  :type => String,
                  :description => 'HTTP Host header to send'

        # HTTP user to authenticate as
        parameter :http_user,
                  :type => String,
                  :description => 'HTTP user to authenticate as'

        # HTTP password to authenticate with
        parameter :http_password,
                  :type => String,
                  :description => 'HTTP password to authenticate with'

        # HTTP proxy information
        parameter :http_proxy,
                  :description => 'HTTP proxy information'

        # HTTP `User-Agent` header to send
        parameter :http_user_agent,
                  :type => String,
                  :description => 'HTTP User-Agent header to send'

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
        def http_session(options={},&block)
          Net.http_session(http_merge_options(options),&block)
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
          Net.http_request(http_merge_options(options),&block)
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
          Net.http_copy(http_merge_options(options),&block)
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
          Net.http_delete(http_merge_options(options),&block)
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
          Net.http_get(http_merge_options(options),&block)
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
          Net.http_get_body(http_merge_options(options),&block)
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
          Net.http_head(http_merge_options(options),&block)
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
          Net.http_lock(http_merge_options(options),&block)
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
          Net.http_mkcol(http_merge_options(options),&block)
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
          Net.http_move(http_merge_options(options),&block)
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
          Net.http_options(http_merge_options(options),&block)
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
          Net.http_post(http_merge_options(options),&block)
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
          Net.http_post_body(http_merge_options(options),&block)
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
          Net.http_prop_find(http_merge_options(options),&block)
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
          Net.http_prop_patch(http_merge_options(options),&block)
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
          Net.http_trace(http_merge_options(options),&block)
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
          Net.http_unlock(http_merge_options(options),&block)
        end

        private

        def http_merge_options(options={})
          options[:host] ||= self.host if self.host
          options[:port] ||= self.port if self.port

          options[:headers] ||= {}
          headers = options[:headers]

          headers[:host] ||= self.http_vhost if self.http_vhost

          options[:user] ||= self.http_user if self.http_user
          options[:password] ||= self.http_password if self.http_password

          options[:proxy] ||= self.http_proxy if self.http_proxy
          options[:user_agent] ||= self.http_user_agent if self.http_user_agent

          return options
        end
      end
    end
  end
end

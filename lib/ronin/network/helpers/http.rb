#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'ronin/network/helpers/helper'
require 'ronin/network/http'

module Ronin
  module Network
    module Helpers
      module HTTP
        include Helper

        protected

        #
        # Resets the HTTP proxy settings.
        #
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        #   The +POSTDATA+ to send with the HTTP Post request.
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
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
        # @since 0.3.0
        #
        def http_unlock(options={},&block)
          Net.http_unlock(http_merge_options(options),&block)
        end

        private

        def http_merge_options(options={})
          options[:host] ||= @host if @host
          options[:port] ||= @port if @port

          options[:headers] ||= {}
          headers = options[:headers]

          headers[:host] ||= @http_vhost if @http_vhost

          options[:user] ||= @http_user if @http_user
          options[:password] ||= @http_password if @http_password

          options[:proxy] ||= @http_proxy if @http_proxy
          options[:user_agent] ||= @http_user_agent if @http_user_agent

          return options
        end
      end
    end
  end
end

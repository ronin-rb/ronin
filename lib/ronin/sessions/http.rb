#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
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
#++
#

require 'ronin/sessions/session'
require 'ronin/network/http'

module Ronin
  module Sessions
    module HTTP
      include Session

      protected

      #
      # Resets the HTTP proxy settings.
      #
      def disable_http_proxy
        @http_proxy = nil
      end

      #
      # Connects to the HTTP server using the given _options_. If a _block_
      # is given it will be passed the newly created <tt>Net::HTTP</tt>
      # object.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to the
      #                  HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      #
      def http_session(options={},&block)
        Net.http_session(http_merge_options(options),&block)
      end

      #
      # Connects to the HTTP server and sends an HTTP Request using the
      # given _options_. If a _block_ is given it will be passed the newly
      # created HTTP Request object. Returns the
      # <tt>Net::HTTP::Response</tt> that was returned.
      #
      # _options_ may contain the following keys:
      # <tt>:method</tt>:: The HTTP method to use for the request.
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults
      #                  to <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to.
      #                                    Defaults to <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the
      #                     request. May use Strings or Symbols for the
      #                     keys of the Hash.
      #
      def http_request(options={},&block)
        Net.http_request(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Copy request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Copy request. May use Strings or Symbols for the
      #                     keys of the Hash.
      #
      def http_copy(options={},&block)
        Net.http_copy(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Delete request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Delete request. May use Strings or Symbols for
      #                     the keys of the Hash.
      #
      def http_delete(options={},&block)
        Net.http_delete(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Get request with the given _options_. If a _block_
      # is given, it will be passed the response from the HTTP server.
      # Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Get request. May use Strings or Symbols for the
      #                     keys of the Hash.
      #
      def http_get(options={},&block)
        Net.http_get(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Get request with the given _options_. If a _block_
      # is given, it will be passed the response body from the HTTP server.
      # Returns the response body from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Get request. May use Strings or Symbols for the
      #                     keys of the Hash.
      #
      def http_get_body(options={},&block)
        Net.http_get_body(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Head request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Head request. May use Strings or Symbols for the
      #                     keys of the Hash.
      #
      def http_head(options={},&block)
        Net.http_head(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Lock request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Lock request. May use Strings or Symbols for the
      #                     keys of the Hash.
      #
      def http_lock(options={},&block)
        Net.http_lock(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Mkcol request with the given _options_. If a
      # _block_  is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Mkcol request. May use Strings or Symbols for
      #                     the keys of the Hash.
      #
      def http_mkcol(options={},&block)
        Net.http_mkcol(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Move request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to 
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Move request. May use Strings or Symbols for the
      #                     keys of the Hash.
      #
      def http_move(options={},&block)
        Net.http_move(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Options request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Options request. May use Strings or Symbols for
      #                     the keys of the Hash.
      #
      def http_options(options={},&block)
        Net.http_options(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Post request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:post_data</tt>:: The POSTDATA to send with the HTTP Post
      #                       request.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Post request. May use Strings or Symbols for the
      #                     keys of the Hash.
      #
      def http_post(options={},&block)
        Net.http_post(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Post request with the given _options_. If a
      # _block_ is given, it will be passed the response body from the HTTP
      # server. Returns the response body from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Post request. May use Strings or Symbols for the
      #                     keys of the Hash.
      #
      def http_post_body(options={},&block)
        Net.http_post_body(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Propfind request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Propfind request. May use Strings or Symbols for
      #                     the keys of the Hash.
      #
      def http_prop_find(options={},&block)
        Net.http_prop_find(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Proppatch request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Proppatch request. May use Strings or Symbols
      #                     for the keys of the Hash.
      #
      def http_prop_patch(options={},&block)
        Net.http_prop_patch(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Trace request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Trace request. May use Strings or Symbols for
      #                     the keys of the Hash.
      #
      def http_trace(options={},&block)
        Net.http_trace(http_merge_options(options),&block)
      end

      #
      # Performes an HTTP Unlock request with the given _options_. If a
      # _block_ is given, it will be passed the response from the HTTP
      # server. Returns the response from the HTTP server.
      #
      # _options_ may contain the following keys:
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to
      #                  the HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
      #                   the HTTP server. Defaults to
      #                   <tt>Ronin::Network::HTTP.proxy</tt>.
      #                   <tt>:host</tt>:: The HTTP proxy host to connect
      #                                    to.
      #                   <tt>:port</tt>:: The HTTP proxy port to connect
      #                                    to. Defaults to
      #                                    <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
      #                   <tt>:user</tt>:: The user to authenticate with
      #                                    when connecting to the HTTP
      #                                    proxy.
      #                   <tt>:password</tt>:: The password to authenticate
      #                                        with when connecting to the
      #                                        HTTP proxy.
      # <tt>:headers</tt>:: A Hash of the HTTP Headers to send with the HTTP
      #                     Unlock request. May use Strings or Symbols for
      #                     the keys of the Hash.
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

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
      # <tt>:host</tt>:: The host the HTTP server is running on.
      # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
      #                  <tt>Net::HTTP.default_port</tt>.
      # <tt>:url</tt>:: The full URL to request.
      # <tt>:user</tt>:: The user to authenticate with when connecting to the
      #                  HTTP server.
      # <tt>:password</tt>:: The password to authenticate with when
      #                      connecting to the HTTP server.
      # <tt>:path</tt>:: The path to request from the HTTP server.
      #
      def http_session(options={},&block)
        Net.http_session(http_merge_options(options),&block)
      end

      def http_request(options={},&block)
        Net.http_request(http_merge_options(options),&block)
      end

      def http_copy(options={},&block)
        Net.http_copy(http_merge_options(options),&block)
      end

      def http_delete(options={},&block)
        Net.http_delete(http_merge_options(options),&block)
      end

      def http_get(options={},&block)
        Net.http_get(http_merge_options(options),&block)
      end

      def http_get_body(options={},&block)
        Net.http_get_body(http_merge_options(options),&block)
      end

      def http_head(options={},&block)
        Net.http_head(http_merge_options(options),&block)
      end

      def http_lock(options={},&block)
        Net.http_lock(http_merge_options(options),&block)
      end

      def http_mkcol(options={},&block)
        Net.http_mkcol(http_merge_options(options),&block)
      end

      def http_move(options={},&block)
        Net.http_move(http_merge_options(options),&block)
      end

      def http_options(options={},&block)
        Net.http_options(http_merge_options(options),&block)
      end

      def http_post(options={},&block)
        Net.http_post(http_merge_options(options),&block)
      end

      def http_post_body(options={},&block)
        Net.http_post_body(http_merge_options(options),&block)
      end

      def http_prop_find(options={},&block)
        Net.http_prop_find(http_merge_options(options),&block)
      end

      def http_prop_path(options={},&block)
        Net.http_prop_path(http_merge_options(options),&block)
      end

      def http_trace(options={},&block)
        Net.http_trace(http_merge_options(options),&block)
      end

      def http_unlock(options={},&block)
        Net.http_unlock(http_merge_options(options),&block)
      end

      private

      def http_merge_options(options={})
        options[:host] ||= @http_host if @http_host
        options[:port] ||= @http_port if @http_port

        options[:user] ||= @http_user if @http_user
        options[:password] ||= @http_password if @http_password

        options[:proxy] ||= @http_proxy if @http_proxy
        options[:user_agent] ||= @http_user_agent if @http_user_agent

        return options
      end
    end
  end
end

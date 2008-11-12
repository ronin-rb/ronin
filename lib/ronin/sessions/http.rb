#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'ronin/network/extensions/http'

module Ronin
  module Sessions
    module HTTP
      include Session

      setup_session do
        parameter :http_user, :description => 'HTTP user'
        parameter :http_password, :description => 'HTTP password'

        parameter :http_proxy,
                  :value => Ronin::Network::HTTP.proxy,
                  :description => 'HTTP Proxy'

        parameter :http_user_agent,
                  :value => Ronin::Network::HTTP.user_agent,
                  :description => 'Web User-Agent'
      end

      protected

      #
      # Resets the HTTP proxy settings.
      #
      def disable_http_proxy
        @http_proxy = Ronin::Network::HTTP.default_proxy
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
        options[:user] ||= @http_user
        options[:password] ||= @http_password

        options[:proxy] ||= @http_proxy
        options[:user_agent] ||= @http_user_agent

        return Net.http_session(options,&block)
      end

    end
  end
end

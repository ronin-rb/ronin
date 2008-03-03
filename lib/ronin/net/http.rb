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

require 'ronin/net/extensions/http'

module Ronin
  module Net
    module HTTP
      DEFAULT_PROXY_PORT = 8080

      def HTTP.default_proxy_port
        @@http_default_proxy_port ||= COMMON_PROXY_PORT
      end

      def HTTP.default_proxy_port=(port)
        @@http_default_proxy_port = port
      end

      def HTTP.proxy
        @@http_proxy ||= {:host => nil, :port => HTTP.default_proxy_port, :user => nil, :pass => nil}
      end

      def HTTP.user_agent
        @@http_user_agent ||= nil
      end

      def HTTP.user_agent=(agent)
        @@http_user_agent = agent
      end

      def HTTP.headers(options={})
        headers = {}

        if options[:accept]
          headers['Accept'] = options[:accept].to_s
        end

        if options[:accept_charset]
          headers['Accept-Charset'] = options[:accept_charset].to_s
        end

        if options[:accept_encoding]
          headers['Accept-Encoding'] = options[:accept_encoding].to_s
        end

        if options[:accept_language]
          headers['Accept-Language'] = options[:accept_language].to_s
        end

        if options[:accept_range]
          headers['Accept-Range'] = options[:accept_range].to_s
        end

        if options[:authorization]
          headers['Authorization'] = options[:authorization].to_s
        end

        if options[:connection]
          headers['Connection'] = options[:connection].to_s
        end

        if options[:date]
          headers['Date'] = options[:date].to_s
        end

        if options[:host]
          options['Host'] = options[:host].to_s
        end

        if options[:if_modified_since]
          options['If-Modified-Since'] = options[:if_modified_since].to_s
        end

        if options[:user_agent]
          headers['User-Agent'] = options[:user_agent]
        elsif HTTP.user_agent
          headers['User-Agent'] = HTTP.user_agent
        end

        if options[:referer]
          headers['Referer'] = options[:referer]
        end

        return headers
      end
    end
  end
end

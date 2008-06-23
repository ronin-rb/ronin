#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
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

require 'ronin/network/extensions/http'
require 'ronin/network/http/exceptions/unknown_request'

module Ronin
  module Network
    module HTTP
      COMMON_PROXY_PORT = 8080

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

        if HTTP.user_agent
          headers['User-Agent'] = HTTP.user_agent
        end

        if options
          options.each do |name,value|
            headers[name.to_s.sub('_','-').capitalize] = value.to_s
          end
        end

        return headers
      end

      def HTTP.request(type,options={})
        name = type.to_s.capitalize

        unless Net::HTTP.const_defined?(name)
          raise(UnknownRequest,"unknown HTTP request type #{name.dump}",caller)
        end

        headers = HTTP.headers(options[:headers])
        request = Net::HTTP.const_get(name).new(options[:path].to_s,headers)

        if options[:user]
          request.basic_auth(options[:user].to_s,options[:password].to_s)
        end

        return request
      end
    end
  end
end

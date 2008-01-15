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

require 'ronin/extensions/uri/http'

require 'net/http'

module Ronin
  module Net
    module HTTP

      include ::Net::HTTP

      METHODS = {
        :copy => Copy,
        :delete => Delete,
        :get => Get,
        :head => Head,
        :lock => Lock,
        :mkcol => Mkcol,
        :move => Move,
        :options => Options,
        :post => Post,
        :put => Put,
        :trace => Trace,
        :unlock => Unlock
      }

      def HTTP.user_agent
        @user_agent ||= nil
      end

      def HTTP.user_agent=(agent)
        @user_agent = agent
      end

      def HTTP.session(opts={},&block)
        rhost = opts[:host]
        rport = opts[:port] || 80

        if (proxy = opts[:proxy])
          proxy_host = proxy[:host]
          proxy_port = proxy[:port] || 8080
          proxy_user = proxy[:user]
          proxy_pass = proxy[:pass]
        end

        sess = Net::HTTP::Proxy(proxy_host,proxy_port,proxy_user,proxy_pass).start(host,port)

        block.call(sess) if block
        return sess
      end

      def HTTP.request(opts={},&block)
        method = opts[:method].to_sym

        unless METHODS.has_key?(method)
          raise(UnknownHTTPMethod,"unknown HTTP method '#{method}'",caller)
        end

        if (url = opts[:url])
          url = URI.parse(url)

          opts[:host] = url.host
          opts[:port] = url.port
          opts[:path] = url.path_query
        end

        req = METHODS[method].new(opts[:path],opts[:header])

        HTTP.session(opts) do |http|
          resp = http.request(req)

          block.call(resp) if block
          return resp
        end
      end

      def HTTP.get(opts={},&block)
        opts[:method] = :get

        return HTTP.request(opts,&block)
      end

      def HTTP.post(opts={},&block)
        if (url = opts[:url])
          url = URI.parse(url)

          opts[:host] = url.host
          opts[:port] = url.port
          opts[:path] = url.path
        end

        req = Net::HTTP::Post.new(opts[:path],opts[:headers])

        HTTP.session(opts) do |http|
          resp = http.post_form(opts[:path],opts[:postdata])

          block.call(resp) if block
          return resp
        end
      end
    end
  end
end

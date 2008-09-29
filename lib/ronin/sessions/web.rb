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
require 'ronin/web'

module Ronin
  module Sessions
    module Web
      include Session

      setup_session do
        parameter :web_proxy, :value => Ronin::Web.proxy, :description => 'Web Proxy'
        parameter :web_user_agent, :value => Ronin::Web.user_agent, :description => 'Web User-Agent'
      end

      protected

      def web_agent(options={},&block)
        options[:proxy] ||= @web_proxy
        options[:user_agent] ||= @web_user_agent

        return Ronin::Web.agent(options,&block)
      end

      def web_get(uri,options={},&block)
        page = web_agent(options).get(uri)

        block.call(page) if block
        return page
      end

      def web_get_body(uri,options={},&block)
        body = web_agent(options).get(uri).body

        block.call(body) if block
        return body
      end

      def web_post(uri,options={},&block)
        page = web_agent(options).post(uri)

        block.call(page) if block
        return page
      end

      def web_post_body(uri,options={},&block)
        body = web_agent(options).post(uri).body

        block.call(body) if block
        return body
      end
    end
  end
end

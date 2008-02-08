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

require 'ronin/web'
require 'ronin/parameters'
require 'ronin/parameters/exceptions/param_not_found'

module Ronin
  module Sessions
    module Web
      include Parameters

      def self.included(base)
        base.module_eval do
          parameter :web_proxy, :value => Web.proxy, :description => 'Web Proxy'
          parameter :web_user_agent, :value => Web.user_agent, :description => 'Web User-Agent'
        end
      end

      def self.excluded(base)
        base.instance_eval do
          parameter :web_proxy, :value => Web.proxy, :description => 'Web Proxy'
          parameter :web_user_agent, :value => Web.user_agent, :description => 'Web User-Agent'
        end
      end

      protected

      def web_agent(options={})
        options[:proxy] ||= @web_proxy
        options[:user_agent] ||= @web_user_agent

        return Web.agent(options)
      end

      def web_get(uri,options={},&block)
        options[:proxy] ||= @web_proxy
        options[:user_agent] ||= @web_user_agent

        return Web.get(uri,options,&block)
      end

      def web_get_text(uri,options={},&block)
        options[:proxy] ||= @web_proxy
        options[:user_agent] ||= @web_user_agent

        return Web.get_text(uri,options,&block)
      end

      def web_post(uri,options={},&block)
        options[:proxy] ||= @web_proxy
        options[:user_agent] ||= @web_user_agent

        return Web.post(uri,options,&block)
      end

      def web_post_text(uri,options={},&block)
        options[:proxy] ||= @web_proxy
        options[:user_agent] ||= @web_user_agent

        return Web.post_text(uri,options,&block)
      end
    end
  end
end

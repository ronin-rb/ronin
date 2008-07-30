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

require 'ronin/network/http'

require 'uri/http'
require 'mechanize'
require 'open-uri'

module Ronin
  module Web
    #
    # Returns the +Hash+ of the Ronin Web proxy information.
    #
    def Web.proxy
      Network::HTTP.proxy
    end

    #
    # Creates a HTTP URI based from the given _proxy_info_ hash. The
    # _proxy_info_ hash defaults to Web.proxy, if not given.
    #
    def Web.proxy_url(proxy_info=Web.proxy)
      if Web.proxy[:host]
        userinfo = nil

        if (Web.proxy[:user] || Web.proxy[:password])
          userinfo = "#{Web.proxy[:user]}:#{Web.proxy[:password]}"
        end

        return URI::HTTP.build(:host => Web.proxy[:host],
                               :port => Web.proxy[:port],
                               :userinfo => userinfo,
                               :path => '/')
      end
    end

    #
    # Returns the supported Web User-Agent Aliases.
    #
    def Web.user_agent_aliases
      WWW::Mechanize::AGENT_ALIASES
    end

    #
    # Returns the Ronin Web User-Agent
    #
    def Web.user_agent
      Network::HTTP.user_agent
    end

    #
    # Sets the Ronin Web User-Agent to the specified _new_agent_.
    #
    def Web.user_agent=(new_agent)
      Network::HTTP.user_agent = new_agent
    end

    #
    # Sets the Ronin Web User-Agent to the specified user agent alias
    # _name_.
    #
    def Web.user_agent_alias=(name)
      Network::HTTP.user_agent = Web.user_agent_aliases[name.to_s]
    end

    #
    # Opens the _url_ with the given _options_. The contents of the _url_
    # will be returned.
    #
    # _options_ may contain the following keys:
    # <tt>:user_agent_alias</tt>:: The User-Agent Alias to use.
    # <tt>:user_agent</tt>:: The User-Agent string to use.
    # <tt>:proxy</tt>:: A +Hash+ of the proxy information to use.
    #
    #   Web.open('http://www.hackety.org/')
    #
    #   Web.open('http://tenderlovemaking.com/',
    #     :user_agent_alias => 'Linux Mozilla')
    #
    #   Web.open('http://www.wired.com/', :user_agent => 'the future')
    #
    def Web.open(url,options={})
      headers = {}

      if options[:user_agent_alias]
        headers['User-Agent'] = Web.user_agent_aliases[options[:user_agent_alias]]
      elsif options[:user_agent]
        headers['User-Agent'] = options[:user_agent]
      elsif Web.user_agent
        headers['User-Agent'] = Web.user_agent
      end

      proxy = (options[:proxy] || Web.proxy)
      if proxy[:host]
        headers[:proxy] = Web.proxy_url(proxy)
      end

      return Kernel.open(url,headers)
    end

    #
    # Creates a new Mechanize agent with the given _options_.
    #
    # _options_ may contain the following keys:
    # <tt>:user_agent_alias</tt>:: The User-Agent Alias to use.
    # <tt>:user_agent</tt>:: The User-Agent string to use.
    # <tt>:proxy</tt>:: A +Hash+ of the proxy information to use.
    #
    #   Web.agent
    #   Web.agent(:user_agent_alias => 'Linux Mozilla')
    #   Web.agent(:user_agent => 'wooden pants')
    #
    def Web.agent(options={},&block)
      agent = WWW::Mechanize.new

      if options[:user_agent_alias]
        agent.user_agent_alias = options[:user_agent_alias]
      elsif options[:user_agent]
        agent.user_agent = options[:user_agent]
      elsif Web.user_agent
        agent.user_agent = Web.user_agent
      end

      proxy = (options[:proxy] || Web.proxy)
      if proxy[:host]
        agent.set_proxy(proxy[:host],proxy[:port],proxy[:user],proxy[:password])
      end

      block.call(agent) if block
      return agent
    end

    #
    # Gets the specified _url_ with the given _options_. If a _block_ is
    # given, it will be passed the retrieved page.
    #
    # _options_ may contain the following keys:
    # <tt>:user_agent_alias</tt>:: The User-Agent Alias to use.
    # <tt>:user_agent</tt>:: The User-Agent string to use.
    # <tt>:proxy</tt>:: A +Hash+ of the proxy information to use.
    #
    #   Web.get('http://www.0x000000.com') # => WWW::Mechanize::Page
    #
    #   Web.get('http://www.rubyinside.com') do |page|
    #     page.search('div.post/h2/a').each do |title|
    #       puts title.inner_text
    #     end
    #   end
    #
    def Web.get(url,options={},&block)
      page = Web.agent(options).get(url)

      block.call(page) if block
      return page
    end

    #
    # Gets the specified _url_ with the given _options_, returning the body
    # of the requested page. If a _block_ is given, it will be passed the
    # body of the retrieved page.
    #
    # _options_ may contain the following keys:
    # <tt>:user_agent_alias</tt>:: The User-Agent Alias to use.
    # <tt>:user_agent</tt>:: The User-Agent string to use.
    # <tt>:proxy</tt>:: A +Hash+ of the proxy information to use.
    #
    #   Web.get_body('http://www.rubyinside.com') # => String
    #
    #   Web.get_body('http://www.rubyinside.com') do |body|
    #     puts body
    #   end
    #
    def Web.get_body(url,options={},&block)
      body = Web.get(url,options).body

      block.call(body) if block
      return body
    end

    #
    # Posts the specified _url_ with the given _options_. If a _block_ is
    # given, it will be passed the posted page.
    #
    # _options_ may contain the following keys:
    # <tt>:query</tt>:: The query parameters to post to the specified _url_.
    # <tt>:user_agent_alias</tt>:: The User-Agent Alias to use.
    # <tt>:user_agent</tt>:: The User-Agent string to use.
    # <tt>:proxy</tt>:: A +Hash+ of the proxy information to use.
    #
    #   Web.post('http://www.rubyinside.com') # => WWW::Mechanize::Page
    #
    def Web.post(url,options={},&block)
      query = (options[:query] || {})
      page = Web.agent(options).post(url,query)

      block.call(page) if block
      return page
    end

    #
    # Poststhe specified _url_ with the given _options_, returning the body
    # of the posted page. If a _block_ is given, it will be passed the
    # body of the posted page.
    #
    # _options_ may contain the following keys:
    # <tt>:user_agent_alias</tt>:: The User-Agent Alias to use.
    # <tt>:user_agent</tt>:: The User-Agent string to use.
    # <tt>:proxy</tt>:: A +Hash+ of the proxy information to use.
    #
    #   Web.post_body('http://www.rubyinside.com') # => String
    #
    #   Web.post_body('http://www.rubyinside.com') do |body|
    #     puts body
    #   end
    #
    def Web.post_body(url,options={},&block)
      body = Web.post(url,options).body

      block.call(body) if block
      return body
    end
  end
end

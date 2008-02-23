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

require 'uri/http'
require 'mechanize'
require 'open-uri'

module Ronin
  module Web
    # Common proxy port.
    COMMON_PROXY_PORT = 8080

    #
    # Returns the +Hash+ of the Ronin Web proxy information.
    #
    def Web.proxy
      @@web_proxy ||= {:host => nil, :port => COMMON_PROXY_PORT, :user => nil, :pass => nil}
    end

    #
    # Creates a HTTP URI based from the given _proxy_info_ hash. The
    # _proxy_info_ hash defaults to Web.proxy, if not given.
    #
    def Web.proxy_uri(proxy_info=Web.proxy)
      if Web.proxy[:host]
        return URI::HTTP.build(:host => Web.proxy[:host],
                               :port => Web.proxy[:port],
                               :userinfo => "#{Web.proxy[:user]}:#{Web.proxy[:pass]}",
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
      @@web_user_agent ||= nil
    end

    #
    # Sets the Ronin Web User-Agent to the specified _new_agent_.
    #
    def Web.user_agent=(new_agent)
      @@web_user_agent = new_agent
    end

    #
    # Opens the _uri_ with the given _options_. The contents of the _uri_
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
    #   Web.open('http://www.wired.com/', :user_agent => 'the future')
    #
    def Web.open(uri,options={})
      headers = {}

      if options[:user_agent_alias]
        headers['User-Agent'] = WWW::Mechanize::AGENT_ALIASES[opts[:user_agent_alias]]
      elsif options[:user_agent]
        headers['User-Agent'] = options[:user_agent]
      elsif Web.user_agent
        headers['User-Agent'] = Web.user_agent
      end

      proxy = (options[:proxy] || Web.proxy)
      if proxy[:host]
        headers[:proxy] = Web.proxy_uri(proxy)
      end

      return Kernel.open(uri,headers)
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
    def Web.agent(options={})
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
        agent.set_proxy(proxy[:host],proxy[:port],proxy[:user],proxy[:pass])
      end

      return agent
    end

    #
    # Gets the specified _uri_ with the given _options_. If a _block_ is
    # given, it will be passed the retrieved page.
    #
    # _options_ may contain the following keys:
    # <tt>:user_agent_alias</tt>:: The User-Agent Alias to use.
    # <tt>:user_agent</tt>:: The User-Agent string to use.
    # <tt>:proxy</tt>:: A +Hash+ of the proxy information to use.
    #
    #   Web.get('http://www.rubyinside.com') # => WWW::Mechanize::Page
    #
    #   Web.get('http://www.rubyinside.com') do |page|
    #     page.search('div.post/h2/a').each do |title|
    #       puts title.inner_text
    #     end
    #   end
    #
    def Web.get(uri,options={},&block)
      page = Web.agent(options).get(uri)

      block.call(page) if block
      return page
    end

    #
    # Gets the specified _uri_ with the given _options_, returning the text
    # of the requested page. If a _block_ is given, it will be passed the
    # text of the retrieved page.
    #
    # _options_ may contain the following keys:
    # <tt>:user_agent_alias</tt>:: The User-Agent Alias to use.
    # <tt>:user_agent</tt>:: The User-Agent string to use.
    # <tt>:proxy</tt>:: A +Hash+ of the proxy information to use.
    #
    #   Web.get_text('http://www.rubyinside.com') # => String
    #
    #   Web.get_text('http://www.rubyinside.com') do |page|
    #     puts page
    #   end
    #
    def Web.get_text(uri,options={},&block)
      text = Web.get(uri,options).body

      block.call(text) if block
      return text
    end

    #
    # Posts the specified _uri_ with the given _options_. If a _block_ is
    # given, it will be passed the posted page.
    #
    # _options_ may contain the following keys:
    # <tt>:user_agent_alias</tt>:: The User-Agent Alias to use.
    # <tt>:user_agent</tt>:: The User-Agent string to use.
    # <tt>:proxy</tt>:: A +Hash+ of the proxy information to use.
    #
    #   Web.post('http://www.rubyinside.com') # => WWW::Mechanize::Page
    #
    def Web.post(uri,options={},&block)
      page = Web.agent(options).post(uri)

      block.call(page) if block
      return page
    end

    #
    # Poststhe specified _uri_ with the given _options_, returning the text
    # of the posted page. If a _block_ is given, it will be passed the
    # text of the posted page.
    #
    # _options_ may contain the following keys:
    # <tt>:user_agent_alias</tt>:: The User-Agent Alias to use.
    # <tt>:user_agent</tt>:: The User-Agent string to use.
    # <tt>:proxy</tt>:: A +Hash+ of the proxy information to use.
    #
    #   Web.post_text('http://www.rubyinside.com') # => String
    #
    #   Web.post_text('http://www.rubyinside.com') do |page|
    #     puts page
    #   end
    #
    def Web.post_text(uri,options={},&block)
      text = Web.post(uri,options).body

      block.call(text) if block
      return text
    end
  end
end

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

require 'ronin/network/http'
require 'ronin/extensions/uri/http'

require 'net/http'

module Net
  def Net.http_session(options={},&block)
    host = options[:host]
    port = (options[:port] || ::Net::HTTP.default_port)

    if options[:url]
      url = URI(options[:url].to_s)

      host = url.host
      port = url.port

      options[:user] = url.user if url.user
      options[:password] = url.password if url.password

      if url.query
        options[:path] = "#{url.path}?#{url.query}"
      else
        options[:path] = url.path
      end
    end

    proxy = (options[:proxy] || Ronin::Network::HTTP.proxy)

    if proxy
      proxy_host = proxy[:host]
      proxy_port = (proxy[:port] || Ronin::Net::HTTP.default_proxy_port)
      proxy_user = proxy[:user]
      proxy_pass = proxy[:password]
    end

    sess = Net::HTTP::Proxy(proxy_host,proxy_port,proxy_user,proxy_pass).start(host,port)

    block.call(sess) if block
    return sess
  end

  def Net.http_copy(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:copy,options))

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_delete(options={},&block)
    Net.http_session(options) do |http|
      req = Ronin::Network::HTTP.request(:delete,options)
      req['Depth'] = (options[:depth].to_s || 'Infinity')

      resp = http.request(req)

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_get(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:get,options))

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_get_body(options={},&block)
    Net.http_get(options,&block).body
  end

  def Net.http_head(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:head,options))

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_lock(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:lock,options),options[:body])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_mkcol(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:mkcol,options),options[:body])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_move(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:move,options))

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_options(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:options,options))

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_post(options={},&block)
    Net.http_session(options) do |http|
      req = Ronin::Network::HTTP.request(:post,options)
      req.set_form_data(options[:data]) if options[:data]

      resp = http.request(req)

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_post_body(options={},&block)
    Net.http_post(options,&block).body
  end

  def Net.http_prop_find(options={},&block)
    Net.http_session(options) do |http|
      req = Ronin::Network::HTTP.request(:propfind,options)
      req['Depth'] = (options[:depth] || '0')

      resp = http.request(req,options[:body])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_prop_path(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:proppath,options),options[:body])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_trace(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:trace,options))

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_unlock(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:unlock,options),options[:body])

      block.call(resp) if block
      return resp
    end
  end
end

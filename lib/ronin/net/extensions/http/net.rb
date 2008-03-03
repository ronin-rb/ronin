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

require 'ronin/net/http'
require 'ronin/extensions/uri/http'

require 'net/http'

module Net
  def Net.http_session(options={},&block)
    if options[:url]
      url = URI(options[:url])

      options[:host] ||= url.host
      options[:port] ||= url.port

      options[:user] ||= url.user
      options[:password] ||= url.password

      if url.query
        options[:path] ||= "#{url.path}?#{url.query}"
      else
        options[:path] ||= url.path
      end
    end

    host = options[:host]
    port = (options[:port] || ::Net::HTTP.default_port)

    proxy = (options[:proxy] || HTTP.proxy)

    if proxy
      proxy_host = proxy[:host]
      proxy_port = (proxy[:port] || Ronin::Net::HTTP.default_proxy_port)
      proxy_user = proxy[:user]
      proxy_pass = proxy[:pass]
    end

    sess = Net::HTTP::Proxy(proxy_host,proxy_port,proxy_user,proxy_pass).start(host,port)

    block.call(sess) if block
    return sess
  end

  def Net.http_copy(options={},&block)
    Net.http_session(options) do |http|
      resp = http.copy(options[:path],options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_delete(options={},&block)
    options[:headers] ||= {'Depth' => 'Infinity'}

    Net.http_session(options) do |http|
      resp = http.delete(options[:path],options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_get(opts={},&block)
    Net.http_session(opts) do |http|
      resp = http.get(opts[:path],opts[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_get_body(options={},&block)
    Net.http_get(options,&block).body
  end

  def Net.http_head(options={},&block)
    Net.http_session(options) do |http|
      resp = http.head(options[:path],options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_lock(options={},&block)
    Net.http_session(options) do |http|
      resp = http.lock(options[:path],options[:body],options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_mkcol(options={},&block)
    Net.http_session(options) do |http|
      resp = http.mkcol(options[:path],options[:body],options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_move(options={},&block)
    Net.http_session(options) do |http|
      resp = http.move(options[:path],options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_options(options={},&block)
    Net.http_session(options) do |http|
      resp = http.options(options[:path],options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_post(options={},&block)
    options[:data] ||= ''

    Net.http_session(options) do |http|
      resp = http.post(options[:path],options[:data].to_s,options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_post_body(options={},&block)
    Net.http_post(options,&block).body
  end

  def Net.http_prop_find(options={},&block)
    options[:headers] ||= {'Depth' => '0'}

    Net.http_session(options) do |http|
      resp = http.propfind(options[:path],options[:body],options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_prop_path(options={},&block)
    Net.http_session(options) do |http|
      resp = http.proppath(options[:path],options[:body],options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_trace(options={},&block)
    Net.http_session(options) do |http|
      resp = http.trace(options[:path],options[:body],options[:headers])

      block.call(resp) if block
      return resp
    end
  end

  def Net.http_unlock(options={},&block)
    Net.http_session(options) do |http|
      resp = http.unlock(options[:path],options[:body],options[:headers])

      block.call(resp) if block
      return resp
    end
  end
end

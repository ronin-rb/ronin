#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  #
  # Connects to the HTTP server using the given _options_. If a _block_
  # is given it will be passed the newly created <tt>Net::HTTP</tt> object.
  #
  # _options_ may contain the following keys:
  # <tt>:host</tt>:: The host the HTTP server is running on.
  # <tt>:port</tt>:: The port the HTTP server is running on. Defaults to
  #                  <tt>Net::HTTP.default_port</tt>.
  # <tt>:url</tt>:: The full URL to request.
  # <tt>:user</tt>:: The user to authenticate with when connecting to the
  #                  HTTP server.
  # <tt>:password</tt>:: The password to authenticate with when connecting
  #                      to the HTTP server.
  # <tt>:path</tt>:: The path to request from the HTTP server.
  # <tt>:proxy</tt>:: A Hash of proxy settings to use when connecting to
  #                   the HTTP server. Defaults to
  #                   <tt>Ronin::Network::HTTP.proxy</tt>.
  #                   <tt>:host</tt>:: The HTTP proxy host to connect to.
  #                   <tt>:port</tt>:: The HTTP proxy port to connect to.
  #                                    Defaults to <tt>Ronin::Network::HTTP.default_proxy_port</tt>.
  #                   <tt>:user</tt>:: The user to authenticate with
  #                                    when connecting to the HTTP proxy.
  #                   <tt>:password</tt>:: The password to authenticate with
  #                                        when connecting to the HTTP
  #                                        proxy.
  #
  #
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
      proxy_port = (proxy[:port] || Ronin::Network::HTTP.default_proxy_port)
      proxy_user = proxy[:user]
      proxy_pass = proxy[:password]
    end

    sess = Net::HTTP::Proxy(proxy_host,proxy_port,proxy_user,proxy_pass).start(host,port)

    block.call(sess) if block
    return sess
  end

  #
  # Performes an HTTP Copy request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_copy(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:copy,options))

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Delete request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_delete(options={},&block)
    Net.http_session(options) do |http|
      req = Ronin::Network::HTTP.request(:delete,options)
      req['Depth'] = (options[:depth].to_s || 'Infinity')

      resp = http.request(req)

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Get request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_get(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:get,options))

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Get request with the given _options_. If a _block_
  # is given, it will be passed the response body from the HTTP server.
  # Returns the response body from the HTTP server.
  #
  def Net.http_get_body(options={},&block)
    Net.http_get(options,&block).body
  end

  #
  # Performes an HTTP Head request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_head(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:head,options))

      block.call(resp) if block
      return resp
    end
  end

  #
  # Returns +true+ if a HTTP Head request with the given _options_ returns
  # the HTTP status code of 200, returns +false+ otherwise.
  #
  def Net.http_ok?(options={})
    Net.http_head(options).code == 200
  end

  #
  # Performes an HTTP Lock request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_lock(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:lock,options),options[:body])

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Mkcol request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_mkcol(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:mkcol,options),options[:body])

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Move request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_move(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:move,options))

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Options request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_options(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:options,options))

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Post request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_post(options={},&block)
    Net.http_session(options) do |http|
      url = URI(options[:url].to_s)
      post_data = (options[:post_data] || url.query_params)

      req = Ronin::Network::HTTP.request(:post,options)
      req.set_form_data(post_data)

      resp = http.request(req)

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Post request with the given _options_. If a _block_
  # is given, it will be passed the response body from the HTTP server.
  # Returns the response body from the HTTP server.
  #
  def Net.http_post_body(options={},&block)
    Net.http_post(options,&block).body
  end

  #
  # Performes an HTTP Propfind request with the given _options_. If a
  # _block_ is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_prop_find(options={},&block)
    Net.http_session(options) do |http|
      req = Ronin::Network::HTTP.request(:propfind,options)
      req['Depth'] = (options[:depth] || '0')

      resp = http.request(req,options[:body])

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Proppath request with the given _options_. If a
  # _block_ is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_prop_path(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:proppath,options),options[:body])

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Trace request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_trace(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:trace,options))

      block.call(resp) if block
      return resp
    end
  end

  #
  # Performes an HTTP Unlock request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_unlock(options={},&block)
    Net.http_session(options) do |http|
      resp = http.request(Ronin::Network::HTTP.request(:unlock,options),options[:body])

      block.call(resp) if block
      return resp
    end
  end
end

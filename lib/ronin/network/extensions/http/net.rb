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
  def Net.http_session(options={},&block)
    options = Ronin::Network::HTTP.expand_options(options)

    host = options[:host]
    port = options[:port]
    proxy = options[:proxy]

    sess = Net::HTTP::Proxy(proxy[:host],proxy[:port],proxy[:user],proxy[:pass]).start(host,port)

    if block
      if block.arity == 2
        block.call(sess,expanded_options)
      else
        block.call(sess)
      end
    end

    return sess
  end

  #
  # Connects to the HTTP server using the given _options_. If a _block_
  # is given it will be passed the newly created <tt>Net::HTTP</tt> object.
  #
  # _options_ may contain the following keys:
  # <tt>:method</tt>:: The HTTP method to use for the request.
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
  def Net.http_request(options={},&block)
    resp = nil

    Net.http_session(options) do |http,expanded_options|
     http_method = expanded_options.delete(:method),
     http_body = expanded_options.delete(:body)

      req = Ronin::Network::HTTP.request(
        http_method,
        expanded_options
      )

      if block
        if block.arity == 2
          block.call(req,expanded_options)
        else
          block.call(req)
        end
      end

      resp = http.request(req,http_body)
    end

    return resp
  end

  #
  # Performes an HTTP Copy request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_copy(options={},&block)
    resp = Net.http_request(options.merge(:method => :copy))

    block.call(resp) if block
    return resp
  end

  #
  # Performes an HTTP Delete request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_delete(options={},&block)
    # set the HTTP Depth header
    options = {:depth => 'Infinity'}.merge(options)

    resp = Net.http_request(options.merge(:method => :delete))

    block.call(resp) if block
    return resp
  end

  #
  # Performes an HTTP Get request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_get(options={},&block)
    resp = Net.http_request(options.merge(:method => :get))

    block.call(resp) if block
    return resp
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
    resp = Net.http_request(options.merge(:method => :head))

    block.call(resp) if block
    return resp
  end

  #
  # Returns +true+ if a HTTP Head request with the given _options_ returns
  # the HTTP status code of 200, returns +false+ otherwise.
  #
  def Net.http_ok?(options={})
    Net.http_head(options).code == 200
  end

  #
  # Returns the HTTP Server header for the given _options_.
  #
  #   Net.http_server(:url => 'http://www.darkc0de.com/)
  #   # => "Apache/2.2.11 (Unix) PHP/4.4.9 mod_ssl/2.2.11 OpenSSL/0.9.8c
  #    mod_fastcgi/2.4.6 Phusion_Passenger/2.1.2 DAV/2 SVN/1.4.2"
  #
  def Net.http_server(options={})
    Net.http_head(options)['server']
  end

  #
  # Returns the HTTP X-Powered-By header for the given _options_.
  #
  #   Net.http_powered_by(:url => 'http://www.stalkdaily.com/')
  #   # => "PHP/5.2.9"
  #
  def Net.http_powered_by(options={})
    resp = Net.http_head(options)

    if resp.code != 200
      resp = Net.http_get(options)
    end

    return resp['x-powered-by']
  end

  #
  # Performes an HTTP Lock request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_lock(options={},&block)
    resp = Net.http_request(options.merge(:method => :lock))

    block.call(resp) if block
    return resp
  end

  #
  # Performes an HTTP Mkcol request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_mkcol(options={},&block)
    resp = Net.http_request(options.merge(:method => :mkcol))

    block.call(resp) if block
    return resp
  end

  #
  # Performes an HTTP Move request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_move(options={},&block)
    resp = Net.http_request(options.merge(:method => :move))

    block.call(resp) if block
    return resp
  end

  #
  # Performes an HTTP Options request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_options(options={},&block)
    resp = Net.http_request(options.merge(:method => :options))

    block.call(resp) if block
    return resp
  end

  #
  # Performes an HTTP Post request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_post(options={},&block)
    options = options.merge(:method => :post)
    post_data = options.delete(:post_data)

    if options[:url]
      url = URI(options[:url].to_s)
      post_data ||= url.query_params
    end

    resp = Net.http_request(options) do |req,expanded_options|
      req.set_form_data(post_data) if post_data
    end

    block.call(resp) if block
    return resp
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
    # set the HTTP Depth header
    options = {:depth => '0'}.merge(options)

    resp = Net.http_request(options.merge(:method => :propfind))

    block.call(resp) if block
    return resp
  end

  #
  # Performes an HTTP Proppatch request with the given _options_. If a
  # _block_ is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_prop_patch(options={},&block)
    resp = Net.http_request(options.merge(:method => :proppatch))

    block.call(resp) if block
    return resp
  end

  #
  # Performes an HTTP Trace request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_trace(options={},&block)
    resp = Net.http_request(options.merge(:method => :trace))

    block.call(resp) if block
    return resp
  end

  #
  # Performes an HTTP Unlock request with the given _options_. If a _block_
  # is given, it will be passed the response from the HTTP server.
  # Returns the response from the HTTP server.
  #
  def Net.http_unlock(options={},&block)
    resp = Net.http_request(options.merge(:method => :unlock))

    block.call(resp) if block
    return resp
  end
end

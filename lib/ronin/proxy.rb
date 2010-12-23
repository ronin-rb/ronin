#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#

require 'ronin/network/http/proxy'
require 'ronin/network/http/http'
require 'ronin/proxy_credential'
require 'ronin/ip_address'
require 'ronin/port'
require 'ronin/model'

require 'dm-timestamps'

module Ronin
  class Proxy

    include Model

    # The primary-key of the proxy
    property :id, Serial

    # The type of proxy
    property :type, String, :set => %w[http socks]

    # Whether the proxy was anonymous
    property :anonymous, Boolean, :default => false

    # The latency for the proxy
    property :latency, Float

    # Specifies whether the proxy is dead or alive
    property :alive, Boolean, :default => true

    # The address of the proxy
    belongs_to :ip_address, :model => 'Ronin::IPAddress'

    # The port of the proxy
    belongs_to :port

    # Any credentials used for the proxy
    has 0..n, :credentials, :model => 'Ronin::ProxyCredential'

    # Specifies when the proxy was first created and last updated at
    timestamps :at

    #
    # Determines if the proxy is an HTTP proxy.
    #
    # @return [Boolean]
    #   Specifies whether the proxy was an HTTP proxy.
    #
    def http?
      self.type == 'http'
    end

    #
    # Determines if the proxy is a SOCKS proxy.
    #
    # @return [Boolean]
    #   Specifies whether the proxy was a SOCKS proxy.
    #
    def socks?
      self.type == 'socks'
    end

    #
    # Creates an HTTP Proxy.
    #
    # @return [Network::HTTP::Proxy]
    #   The HTTP Proxy.
    #
    # @since 0.2.0
    #
    def http_proxy
      proxy = Network::HTTP::Proxy.new(
        :host => self.ip_address.address,
        :port => self.port.number,
      )

      unless self.credentials.empty?
        creds = self.credentials.first

        proxy.user = creds.user
        proxy.password = creds.password
      end

      return proxy
    end

    #
    # Uses the proxy.
    #
    # @return [Boolean]
    #   Specifies if the proxy is being used.
    #
    # @since 0.2.0
    #
    def use!
      if http?
        Network::HTTP.proxy = http_proxy
      elsif socks?
        raise(NotImplementedError,"SOCKS proxies not supported yet")
      end

      return true
    end

    #
    # Tests the proxy.
    #
    # @return [Boolean]
    #   Specifies whether the proxy is alive or dead.
    #
    # @since 0.2.0
    #
    def test
      if http?
        proxy = http_proxy

        if proxy.valid?
          self.alive = true
          self.anonymous = proxy.anonymous?
          self.latency = proxy.latency
          return true
        else
          self.alive = false
          return false
        end
      elsif socks?
        # simply return if it is a SOCKS proxy
        return true
      end
    end

    #
    # Converts the proxy to a String.
    #
    # @return [String]
    #   The String representation of the proxy.
    #
    # @since 0.2.0
    #
    def to_s
      "#{self.ip_address}:#{self.port}"
    end

    #
    # Splats the proxy into multiple variables.
    #
    # @return [Array]
    #   The IP address and port number of the proxy.
    #
    # @example
    #   ip, port = proxy
    #
    # @since 1.0.0
    #
    def to_ary
      [self.ip_address.address, self.port.number]
    end

  end
end

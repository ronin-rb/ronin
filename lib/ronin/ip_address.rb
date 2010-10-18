#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2009-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/model'
require 'ronin/address'
require 'ronin/ip_address_mac_address'
require 'ronin/host_name_ip_address'
require 'ronin/os_guess'
require 'ronin/os'

require 'ipaddr'
require 'resolv'

module Ronin
  class IPAddress < Address

    # The IP Address
    property :address, Property::IPAddress, :required => true,
                                            :unique => true

    # Type of the address
    property :version, Integer, :set => [4, 6],
                                :default => lambda { |ip_addr,version|
                                  if ip_addr.address
                                    if ip_addr.address.ipv6?
                                      6
                                    else
                                      4
                                    end
                                  end
                                }

    # The MAC Addresses associations
    has 0..n, :ip_address_mac_addresses, :model => 'IPAddressMACAddress'

    # The MAC Addresses associated with the IP Address
    has 0..n, :mac_addresses, :through => :ip_address_mac_addresses,
                              :model => 'MACAddress'

    # The host names that the IP Address serves
    has 0..n, :host_name_ip_addresses, :model => 'HostNameIPAddress'

    # The host names associated with the IP Address
    has 0..n, :host_names, :through => :host_name_ip_addresses

    # Open ports of the host
    has 0..n, :open_ports

    # Ports of the host
    has 0..n, :ports, :through => :open_ports

    # Any OS guesses against the IP Address
    has 0..n, :os_guesses, :model => 'OSGuess'

    # Any OSes that the IP Address might be running
    has 0..n, :oses, :through => :os_guesses,
                     :model => 'OS',
                     :via => :os

    #
    # Resolves the host name to an IP Address.
    #
    # @param [String] host_name
    #   The host name to resolve.
    #
    # @return [IPAddress]
    #   The new or previously saved IP Address for the host name.
    #
    # @since 0.4.0
    #
    def IPAddress.resolv(host_name)
      IPAddress.first_or_new(:address => Resolv.getaddress(host_name))
    end

    #
    # Resolves the host name to multiple IP Addresses.
    #
    # @param [String] host_name
    #   The host name to resolve.
    #
    # @return [Array<IPAddress>]
    #   The new or previously saved IP Addresses for the host name.
    #
    # @since 0.4.0
    #
    def IPAddress.resolv_all(host_name)
      Resolv.getaddresses(host_name).map do |ip|
        IPAddress.first_or_new(:address => ip)
      end
    end

    #
    # Performs a reverse lookup on the IP Address.
    #
    # @return [HostName]
    #   The host name associated with the IP Address.
    #
    # @since 0.4.0
    #
    def reverse_lookup
      self.host_names.first_or_new(:address => Resolv.getname(self.address))
    end

    #
    # The MAC Address that was most recently used by the IP Address.
    #
    # @return [MacAddress]
    #   The MAC Address that most recently used the IP Address.
    #
    # @since 0.4.0
    #
    def recent_mac_address
      relation = self.ip_address_mac_addresses.first(
        :order => [:created_at.desc]
      )

      if relation
        return relation.mac_address
      end
    end

    #
    # The host name that was most recently used by the IP Address.
    #
    # @return [HostName]
    #   The host name that most recently used by the IP Address.
    #
    # @since 0.4.0
    #
    def recent_host_name
      relation = self.host_name_ip_addresses.first(
        :order => [:created_at.desc]
      )

      if relation
        return relation.host_name
      end
    end

    #
    # The Operating System that was most recently guessed for the IP Address.
    #
    # @return [OS]
    #   The Operating System that most recently was guessed.
    #
    # @since 0.4.0
    #
    def recent_os_guess
      relation = self.os_guesses.first(:order => [:created_at.desc])

      if relation
        return relation.os
      end
    end

    #
    # Converts the address to an IP address object.
    #
    # @return [IPAddr]
    #   The IPAddr object representing either the IPv4 or IPv6 address.
    #
    # @since 0.4.0
    #
    def to_ip
      self.address
    end

    #
    # Converts the address to an Integer.
    #
    # @return [Integer]
    #   The network representation of the IP address.
    #
    # @since 0.4.0
    #
    def to_i
      self.address.to_i
    end

    #
    # Converts the address to a string.
    #
    # @return [String]
    #   The address.
    #
    # @since 0.4.0
    #
    def to_s
      self.address.to_s
    end

  end
end

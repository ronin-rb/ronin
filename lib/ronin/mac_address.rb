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

require 'ronin/address'
require 'ronin/ip_address_mac_address'
require 'ronin/model'

module Ronin
  class MACAddress < Address

    # The IP Addresses the MAC Address hosts
    has 0..n, :ip_address_mac_addresses, :model => 'IPAddressMACAddress'

    # The IP Addresses associated with the MAC Address
    has 0..n, :ip_addresses, :through => :ip_address_mac_addresses,
                             :model => 'IPAddress'

    #
    # The IP Address that most recently used the MAC Address.
    #
    # @return [IpAddress]
    #   The IP Address that most recently used the MAC Address.
    #
    # @since 0.4.0
    #
    def recent_ip_address
      relation = self.ip_address_mac_addresses.first(
        :order => [:created_at.desc]
      )

      if relation
        return relation.ip_address
      end
    end

    #
    # Converts the MAC address to an Integer.
    #
    # @return [Integer]
    #   The network representation of the MAC address.
    #
    # @since 0.4.0
    #
    def to_i
      self.address.split(':').inject(0) do |bits,char|
        bits = ((bits << 8) | char.hex)
      end
    end

    #
    # Converts the MAC address to a `String`.
    #
    # @return [String]
    #   The MAC address.
    #
    # @since 0.4.0
    #
    def to_s
      self.address.to_s
    end

  end
end

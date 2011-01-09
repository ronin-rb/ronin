#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/address'
require 'ronin/ip_address_mac_address'
require 'ronin/model'

module Ronin
  #
  # Represents MAC addresses that can be stored in the {Database}.
  #
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
    # @since 1.0.0
    #
    def recent_ip_address
      self.ip_address_mac_addresses.all(
        :order => [:created_at.desc]
      ).ip_addresses.first
    end

    #
    # Converts the MAC address to an Integer.
    #
    # @return [Integer]
    #   The network representation of the MAC address.
    #
    # @since 1.0.0
    #
    def to_i
      self.address.split(':').inject(0) do |bits,char|
        bits = ((bits << 8) | char.hex)
      end
    end

  end
end

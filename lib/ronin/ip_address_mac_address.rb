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

require 'ronin/ip_address'
require 'ronin/mac_address'
require 'ronin/model'

require 'dm-timestamps'

module Ronin
  class IPAddressMACAddress

    include Model

    # The primary-key of the join model.
    property :id, Serial

    # The IP Address
    belongs_to :ip_address, :model => 'IPAddress'

    # The Mac Address
    belongs_to :mac_address, :model => 'MACAddress'

    # Tracks when an IP Address becomes associated with a MAC Address
    timestamps :created_at

  end
end

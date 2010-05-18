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

require 'ronin/database/database'

Ronin::Database.upgrade do
  require 'ronin/author'
  require 'ronin/license'
  require 'ronin/arch'
  require 'ronin/os'
  require 'ronin/software'
  require 'ronin/vendor'
  require 'ronin/country'
  require 'ronin/address'
  require 'ronin/mac_address'
  require 'ronin/ip_address_mac_address'
  require 'ronin/ip_address'
  require 'ronin/host_name_ip_address'
  require 'ronin/host_name'
  require 'ronin/port'
  require 'ronin/tcp_port'
  require 'ronin/udp_port'
  require 'ronin/service'
  require 'ronin/open_port'
  require 'ronin/url'
  require 'ronin/credential'
  require 'ronin/service_credential'
  require 'ronin/site_credential'
  require 'ronin/comment'
  require 'ronin/organization'
  require 'ronin/target'
  require 'ronin/campaign'
end

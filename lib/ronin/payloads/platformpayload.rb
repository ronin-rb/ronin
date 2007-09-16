#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'ronin/payloads/payload'
require 'ronin/arch'
require 'ronin/platform'

require 'og'

module Ronin
  module Payloads
    class PlatformPayload < Payload

      # Targeted platform
      has_one :platform, Platform

      # Targeted architecture
      has_one :arch, Arch

      def initialize(platform=nil,arch=nil,&block)
        @platform = platform
        @arch = arch

        super(&block)
      end

    end
  end
end

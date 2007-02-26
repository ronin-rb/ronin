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

require 'exploit'
require 'repo/objectcontext'

module Ronin
  module Repo
    class PayloadContext < ObjectContext

      # The payload object
      attr_reader :payload

      def initialize(category)
	super(category)
	@metadata[:advisory] = nil
	@metadata[:restricted] = nil

	@payload = nil
      end

      def perform_build
	return unless payload
	payload.build! { perform_action(:build) }
      end

      def perform_clean
	return unless payload
	payload.clean! { perform_action(:clean) }
      end

      protected

      # Build action for the payload
      attr_action :build
      
      # Clean action for the payload
      attr_action :clean

    end
  end
end

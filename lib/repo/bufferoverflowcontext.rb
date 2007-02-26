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

require 'bufferoverflow'
require 'repo/platformexploitcontext'

module Ronin
  module Repo
    class BufferOverflowContext < PlatformExploitContext

      def initialize(path)
	super(path)
      end

      def create_exploit!
	@exploit = BufferOverflow.new(self.advisory)
	load_bufferoverflow(@exploit)
      end

      protected

      def target(product_version,platform,buffer_length,return_length,bp,ip,comments=nil)
	@targets << BufferOverflowTarget.new(product_version,platform,buffer_length,return_length,bp,ip,comments)
      end

      def load_bufferoverflow(exploit)
	load_platformexploit(exploit)
      end

    end
  end
end

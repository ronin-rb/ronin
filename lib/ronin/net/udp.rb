#
# Ronin - A ruby development environment designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2007 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'socket'

module Ronin
  module Net
    module UDP
      def UDP.connect(rhost,rport,lhost=nil,lport=nil,&block)
        sock = UDPSocket.new(@rhost,@rport,@lhost,@lport)
        block.call(sock) if block

        return sock
      end

      def UDP.connect_and_recv(rhost,rport,lhost=nil,lport=nil,&block)
        UDP.connect(rhost,rport,lhost,lport) do |sock|
          block.call(sock.read) if block
        end
      end

      def UDP.connect_and_send(data,rhost,rport,lhost=nil,lport=nil,&block)
        UDP.connect(rhost,rport,lhost,lport) do |sock|
          sock.write(data)

          block.call(sock) if block
        end
      end

      def udp_listen(&block)
        # TODO: implement some sort of basic udp server
      end
    end
  end
end

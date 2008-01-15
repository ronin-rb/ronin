#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'socket'

module Ronin
  module Net
    module TCP
      #
      # Creates a new TCPSocket object with the specified _rhost_, _rport_
      # and the given _lhost_ and _lport_. If _block_ is given, it will be
      # passed the newly created TCPSocket object.
      #
      #   TCP.connect('www.hackety.org',80) # => TCPSocket
      #
      #   TCP.connect('www.wired.com',80) do |sock|
      #     puts sock.readlines
      #   end
      #
      def tcp_connect(rhost,rport,lhost=nil,lport=nil,&block)
        sock = TCPSocket.new(rhost,rport,lhost,lport)
        block.call(sock) if block

        return sock
      end

      #
      # Creates a new TCPSocket object with the specified _rhost_ 
      # _rport_, and the given _lhost_ and _lport_. The specified _block_
      # will be passed the first line received from the TCPSocket object.
      # The newly created TCPSocket object will be returned.
      #
      def tcp_connect_and_recv(rhost,rport,lhost=nil,lport=nil,&block)
        tcp_connect(rhost,rport,lhost,lport) do |sock|
          block.call(sock.read) if block
        end
      end

      def tcp_connect_and_send(data,rhost,rport,lhost=nil,lport=nil,&block)
        tcp_connect(rhost,rport,lhost,lport) do |sock|
          sock.write(data)

          block.call(sock) if block
        end
      end
    end
  end
end

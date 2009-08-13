#
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Net
  #
  # Creates a new UDPSocket object with the specified _rhost_, _rport_
  # and the given _lhost_ and _lport_. If _block_ is given, it will be
  # passed the newly created UDPSocket object.
  #
  #   Net.udp_connect('www.hackety.org',80) # => UDPSocket
  #
  #   Net.udp_connect('www.wired.com',80) do |sock|
  #     puts sock.readlines
  #   end
  #
  def Net.udp_connect(rhost,rport,lhost=nil,lport=nil,&block)
    sock = UDPSocket.new(@rhost,@rport,@lhost,@lport)
    block.call(sock) if block

    return sock
  end

  #
  # Creates a new UDPSocket object with the specified _rhost_ 
  # _rport_, and the given _lhost_ and _lport_. The specified _data_ will
  # then be written to the newly created UDPSocket. If a _block_ is given
  # it will be passed the UDPSocket object.
  #
  def Net.udp_connect_and_send(data,rhost,rport,lhost=nil,lport=nil,&block)
    Net.udp_connect(rhost,rport,lhost,lport) do |sock|
      sock.write(data)

      block.call(sock) if block
    end
  end

  #
  # Creates a new UDPSocket object with the specified _rhost_, _rport_
  # and the given _lhost_ and _lport_. If _block_ is given, it will be
  # passed the newly created UDPSocket object. After the UDPSocket object
  # has been passed to the given _block_ it will be closed.
  #
  def Net.udp_session(rhost,rport,lhost=nil,lport=nil,&block)
    Net.udp_connect(rhost,rport,lhost,lport) do |sock|
      block.call(sock) if block
      sock.close
    end

    return nil
  end

  #
  # Connects to the specified _rhost_ and _rport_ with the given _lhost_
  # and _lport_, reads the banner then closes the connection, returning the
  # received banner. If a _block_ is given it will be passed the banner.
  #
  def Net.udp_banner(rhost,rport,lhost=nil,lport=nil,&block)
    Net.udp_session(rhost,rport,lhost,lport) do |sock|
      banner = sock.readline
    end

    block.call(banner) if block
    return banner
  end
end

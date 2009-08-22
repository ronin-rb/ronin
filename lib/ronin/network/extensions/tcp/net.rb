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
  # Creates a new TCPSocket object with the specified _rhost_, _rport_
  # and the given _lhost_ and _lport_. If _block_ is given, it will be
  # passed the newly created TCPSocket object.
  #
  # @example
  #   Net.tcp_connect('www.hackety.org',80) # => TCPSocket
  #
  # @example
  #   Net.tcp_connect('www.wired.com',80) do |sock|
  #     sock.write("GET /\n\n")
  #     puts sock.readlines
  #     sock.close
  #   end
  #
  def Net.tcp_connect(rhost,rport,lhost=nil,lport=nil,&block)
    sock = TCPSocket.new(rhost,rport,lhost,lport)
    block.call(sock) if block

    return sock
  end

  #
  # Creates a new TCPSocket object with the specified _rhost_ 
  # _rport_, and the given _lhost_ and _lport_. The specified _data_ will
  # then be written to the newly created TCPSocket. If a _block_ is given
  # it will be passed the TCPSocket object.
  #
  def Net.tcp_connect_and_send(data,rhost,rport,lhost=nil,lport=nil,&block)
    Net.tcp_connect(rhost,rport,lhost,lport) do |sock|
      sock.write(data)

      block.call(sock) if block
    end
  end

  #
  # Creates a new TCPSocket object with the specified _rhost_, _rport_
  # and the given _lhost_ and _lport_. If _block_ is given, it will be
  # passed the newly created TCPSocket object. After the TCPSocket object
  # has been passed to the given _block_ it will be closed.
  #
  def Net.tcp_session(rhost,rport,lhost=nil,lport=nil,&block)
    Net.tcp_connect(rhost,rport,lhost,lport) do |sock|
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
  # @example
  #   Net.tcp_banner('pop.gmail.com',25)
  #   # => "220 mx.google.com ESMTP c20sm3096959rvf.1"
  #
  def Net.tcp_banner(rhost,rport,lhost=nil,lport=nil,&block)
    banner = nil

    Net.tcp_session(rhost,rport,lhost,lport) do |sock|
      banner = sock.readline.strip
    end

    block.call(banner) if block
    return banner
  end

  #
  # Connects to the specified _rhost_ and _rport_ with the given _lhost_
  # and _lport_, sends the specified _data_ and then closes the connection.
  # Returns +true+ if the _data_ was successfully sent.
  #
  # @example
  #   buffer = "GET /" + ('A' * 4096) + "\n\r"
  #   Net.tcp_send(buffer,'victim.com',80)
  #
  def Net.tcp_send(data,rhost,rport,lhost=nil,lport=nil)
    Net.tcp_session(rhost,rport,lhost,lport) do |sock|
      sock.write(data)
    end

    return true
  end
end

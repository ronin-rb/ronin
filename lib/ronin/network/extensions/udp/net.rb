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
  # Creates a new UDPSocket object with the specified _host_, _port_
  # and the given _local_host_ and _local_port_. If _block_ is given, it
  # will be passed the newly created UDPSocket object.
  #
  # @example
  #   Net.udp_connect('www.hackety.org',80) # => UDPSocket
  #
  # @example
  #   Net.udp_connect('www.wired.com',80) do |sock|
  #     puts sock.readlines
  #   end
  #
  def Net.udp_connect(host,port,local_host=nil,local_port=nil,&block)
    sock = UDPSocket.new(host,port,local_host,local_port)
    block.call(sock) if block

    return sock
  end

  #
  # Creates a new UDPSocket object with the specified _host_, _port_, and
  # the given _local_host_ and _local_port_. The specified _data_ will
  # then be written to the newly created UDPSocket. If a _block_ is given
  # it will be passed the UDPSocket object.
  #
  def Net.udp_connect_and_send(data,host,port,local_host=nil,local_port=nil,&block)
    Net.udp_connect(host,port,local_host,local_port) do |sock|
      sock.write(data)

      block.call(sock) if block
    end
  end

  #
  # Creates a new UDPSocket object with the specified _host_, _port_
  # and the given _local_host_ and _local_port_. If _block_ is given, it
  # will be passed the newly created UDPSocket object. After the UDPSocket
  # object has been passed to the given _block_ it will be closed.
  #
  def Net.udp_session(host,port,local_host=nil,local_port=nil,&block)
    Net.udp_connect(host,port,local_host,local_port) do |sock|
      block.call(sock) if block
      sock.close
    end

    return nil
  end

  #
  # Connects to the specified _host_ and _port_ with the given _local_host_
  # and _local_port_, reads the banner then closes the connection,
  # returning the received banner. If a _block_ is given it will be passed
  # the banner.
  #
  def Net.udp_banner(host,port,local_host=nil,local_port=nil,&block)
    Net.udp_session(host,port,local_host,local_port) do |sock|
      banner = sock.readline
    end

    block.call(banner) if block
    return banner
  end

  #
  # Creates a new UDPServer listening on the specified _host_ and _port_.
  #
  # @param [Integer] port The local port to listen on.
  # @param [String] host The host to bind to.
  # @return [UDPServer] The new UDP server.
  #
  # @example
  #   Net.udp_server(1337)
  #
  # @since 0.3.0
  #
  def Net.udp_server(port,host='0.0.0.0',&block)
    server = UDPServer.new(host,port)

    block.call(server) if block
    return server
  end

  #
  # Creates a new UDPServer listening on the specified _host_ and _port_,
  # passing it to the given _block_ and then closing the server.
  #
  # @param [Integer] port The local port to bind to.
  # @param [String] host The host to bind to.
  # @yield [server] The block which will be called after the _server_ has
  #                 been created. After the block has finished, the
  #                 _server_ will be closed.
  # @yieldparam [UDPServer] server The newly created UDP server.
  # @return [nil]
  #
  # @example
  #   Net.udp_server_session(1337) do |server|
  #     data, sender = server.recvfrom(1024)
  #   end
  #
  # @since 0.3.0
  #
  def Net.udp_server_session(port,host='0.0.0.0',&block)
    server = Net.udp_server(port,host,&block)
    server.close()
    return nil
  end
end

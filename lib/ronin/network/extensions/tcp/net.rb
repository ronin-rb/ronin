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
  # Creates a new TCPSocket object with the specified _host_, _port_
  # and the given _local_host_ and _local_port_. If _block_ is given, it
  # will be passed the newly created TCPSocket object.
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
  def Net.tcp_connect(host,port,local_host=nil,local_port=nil,&block)
    sock = TCPSocket.new(host,port,local_host,local_port)
    block.call(sock) if block

    return sock
  end

  #
  # Creates a new TCPSocket object with the specified _host_, _port_, and
  # the given _local_host_ and _local_port_. The specified _data_ will
  # then be written to the newly created TCPSocket. If a _block_ is given
  # it will be passed the TCPSocket object.
  #
  def Net.tcp_connect_and_send(data,host,port,local_host=nil,local_port=nil,&block)
    Net.tcp_connect(host,port,local_host,local_port) do |sock|
      sock.write(data)

      block.call(sock) if block
    end
  end

  #
  # Creates a new TCPSocket object with the specified _host_, _port_
  # and the given _local_host_ and _local_port_. If _block_ is given, it
  # will be passed the newly created TCPSocket object. After the TCPSocket
  # object has been passed to the given _block_ it will be closed.
  #
  def Net.tcp_session(host,port,local_host=nil,local_port=nil,&block)
    Net.tcp_connect(host,port,local_host,local_port) do |sock|
      block.call(sock) if block
      sock.close
    end

    return nil
  end

  #
  # Connects to the specified _host_ and _port_ with the given
  # _local_host_ and _local_port_, reads the banner then closes the
  # connection, returning the received banner. If a _block_ is given it
  # will be passed the banner.
  #
  # @example
  #   Net.tcp_banner('pop.gmail.com',25)
  #   # => "220 mx.google.com ESMTP c20sm3096959rvf.1"
  #
  def Net.tcp_banner(host,port,local_host=nil,local_port=nil,&block)
    banner = nil

    Net.tcp_session(host,port,local_host,local_port) do |sock|
      banner = sock.readline.strip
    end

    block.call(banner) if block
    return banner
  end

  #
  # Connects to the specified _host_ and _port_ with the given _local_host_
  # and _local_port_, sends the specified _data_ and then closes the
  # connection. Returns +true+ if the _data_ was successfully sent.
  #
  # @example
  #   buffer = "GET /" + ('A' * 4096) + "\n\r"
  #   Net.tcp_send(buffer,'victim.com',80)
  #
  def Net.tcp_send(data,host,port,local_host=nil,local_port=nil)
    Net.tcp_session(host,port,local_host,local_port) do |sock|
      sock.write(data)
    end

    return true
  end

  #
  # Creates a new TCPServer listening on the specified _host_ and _port_.
  #
  # @param [Integer] port The local port to listen on.
  # @param [String] host The host to bind to.
  # @return [TCPServer] The new TCP server.
  #
  # @example
  #   Net.tcp_server(1337)
  #
  # @since 0.3.0
  #
  def Net.tcp_server(port,host='0.0.0.0',&block)
    server = TCPServer.new(host,port)
    server.listen(3)

    block.call(server) if block
    return server
  end

  #
  # Creates a new TCPServer listening on the specified _host_ and _port_,
  # passing it to the given _block_ and then closing the server.
  #
  # @param [Integer] port The local port to bind to.
  # @param [String] host The host to bind to.
  # @yield [server] The block which will be called after the _server_ has
  #                 been created. After the block has finished, the
  #                 _server_ will be closed.
  # @yieldparam [TCPServer] server The newly created TCP server.
  # @return [nil]
  #
  # @example
  #   Net.tcp_server_session(1337) do |server|
  #     client1 = server.accept
  #     client2 = server.accept
  #
  #     client2.write(server.read_line)
  #
  #     client1.close
  #     client2.close
  #   end
  #
  # @since 0.3.0
  #
  def Net.tcp_server_session(port,host='0.0.0.0',&block)
    server = Net.tcp_server(port,host,&block)
    server.close()
    return nil
  end

  #
  # Creates a new TCPServer listening on the specified _host_ and _port_,
  # then accepts only one client.
  #
  # @param [Integer] port The local port to listen on.
  # @param [String] host The host to bind to.
  # @yield [client] The block which will be passed the newly connected
  #                 _client_. After the block has finished, the _client_
  #                 and the server will be closed.
  # @yieldparam [TCPSocket] client The newly connected client.
  # @return [nil]
  #
  # @example
  #   Net.tcp_single_server(1337) do |client|
  #     client.puts 'lol'
  #   end
  #
  # @since 0.3.0
  #
  def Net.tcp_single_server(port,host='0.0.0.0',&block)
    server = TCPServer.new(host,port)
    server.listen(1)

    client = server.accept

    block.call(client) if block

    client.close
    server.close
    return nil
  end
end

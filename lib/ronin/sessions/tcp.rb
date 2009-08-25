#
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
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

require 'ronin/sessions/session'
require 'ronin/network/tcp'

module Ronin
  module Sessions
    module TCP
      include Session

      protected

      #
      # Opens a TCP connection to the host and port specified by the
      # +host+ and +port+ parameters. If the +local_host+ and +local_port+
      # parameters are set, they will be used for the local host and port
      # of the TCP connection. A TCPSocket object will be returned. If
      # a _block_ is given, it will be passed the newly created TCPSocket
      # object.
      #
      def tcp_connect(&block)
        require_variable :host
        require_variable :port

        print_info "Connecting to #{@host}:#{@port} ..."

        return ::Net.tcp_connect(@host,@port,@local_host,@local_port,&block)
      end

      #
      # Connects to the host and port specified by the +host+ and +port+
      # parameters, then sends the specified _data_. If a _block_ is given,
      # it will be passed the newly created TCPSocket object.
      #
      def tcp_connect_and_send(data,&block)
        require_variable :host
        require_variable :port

        print_info "Connecting to #{@host}:#{@port} ..."
        print_debug "Sending data: #{data.inspect}"

        return ::Net.tcp_connect_and_send(data,@host,@port,@local_host,@local_port,&block)
      end

      #
      # Creates a TCP session to the host and port specified by the
      # +host+ and +port+ parameters. If a _block_ is given, it will be
      # passed the temporary TCPSocket object. After the given _block_
      # has returned, the TCPSocket object will be closed.
      #
      def tcp_session(&block)
        require_variable :host
        require_variable :port

        print_info "Connecting to #{@host}:#{@port} ..."

        Net.tcp_session(@host,@port,@local_host,@local_port,&block)

        print_info "Disconnected from #{@host}:#{@port}"
        return nil
      end

      #
      # Connects to the host and port specified by the +host+ and +port+
      # parameters, reads the banner then closes the connection, returning
      # the banner String. If a _block_ is given, it will be passed the
      # banner String.
      #
      def tcp_banner(&block)
        require_variable :host
        require_variable :port

        print_debug "Grabbing banner from #{@host}:#{@port}"

        return ::Net.tcp_banner(@host,@port,@local_host,@local_port,&block)
      end

      #
      # Connects to the host and port specified by the +host+ and +port+
      # parameters, sends the specified _data_ and then closes the
      # connection. Returns +true+ if the data was successfully sent.
      #
      def tcp_send(data)
        require_variable :host
        require_variable :port

        print_info "Connecting to #{@host}:#{@port} ..."
        print_debug "Sending data: #{data.inspect}"

        ::Net.tcp_send(data,@host,@port,@local_host,@local_port)

        print_info "Disconnected from #{@host}:#{@port}"
        return true
      end

      #
      # Creates a new TCPServer object listening on +server_host+ and
      # +server_port+.
      #
      # @yield [server] The given block will be passed the newly created
      #                 server.
      # @yieldparam [TCPServer] server The newly created server.
      # @return [TCPServer] The newly created server.
      #
      # @example
      #   tcp_server
      #
      # @since 0.3.0
      #
      def tcp_server(&block)
        require_variable :server_port

        if @server_host
          print_info "Listening on #{@server_host}:#{@server_port} ..."
        else
          print_info "Listening on #{@server_port} ..."
        end

        return ::Net.tcp_server(@server_port,@server_host,&block)
      end

      #
      # Creates a new TCPServer object listening on +server_host+ and
      # +server_port+, passing it to the given _block then closing the
      # server.
      #
      # @yield [server] The given block will be passed the newly created
      #                 server. When the block has finished, the server
      #                 will be closed.
      # @yieldparam [TCPServer] server The newly created server.
      # @return [nil]
      #
      # @example
      #   tcp_server_session do |server|
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
      def tcp_server_session(&block)
        require_variable :server_port

        if @server_host
          print_info "Listening on #{@server_host}:#{@server_port} ..."
        else
          print_info "Listening on #{@server_port} ..."
        end

        ::Net.tcp_server_session(&block)

        if @server_host
          print_info "Closed #{@server_host}:#{@server_port}"
        else
          print_info "Closed #{@server_port}"
        end

        return nil
      end

      #
      # Creates a new TCPServer object listening on +server_host+ and
      # +server_port+, accepts one client passing it to the given _block_,
      # then closes both the newly connected client and the server.
      #
      # @yield [client] The given block will be passed the newly connected
      #                 client. When the block has finished, the newly
      #                 connected client and the server will be closed.
      # @yieldparam [TCPSocket] client The newly connected client.
      # @return [nil]
      #
      # @example
      #   tcp_single_server do |client|
      #     client.puts 'lol'
      #   end
      #
      # @since 0.3.0
      #
      def tcp_single_server(&block)
        require_variable :server_port

        if @server_host
          print_info "Listening on #{@server_host}:#{@server_port} ..."
        else
          print_info "Listening on #{@server_port} ..."
        end

        ::Net.tcp_single_server do |client|
          client_addr = client.peeraddr
          client_host = (client_addr[2] || client_addr[3])
          client_port = client_addr[1]

          print_info "Client connected #{client_host}:#{client_port}"

          block.call(client) if block

          print_info "Disconnecting client #{client_host}:#{client_port}"
        end

        if @server_host
          print_info "Closed #{@server_host}:#{@server_port}"
        else
          print_info "Closed #{@server_port}"
        end

        return nil
      end
    end
  end
end

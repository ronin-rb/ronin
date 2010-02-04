#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/network/helpers/helper'
require 'ronin/network/udp'

module Ronin
  module Network
    module Helpers
      module UDP
        include Helper

        protected

        #
        # Opens a UDP connection to the host and port specified by the
        # `@host` and `@port` instance variables. If the `@local_host` and
        # `@local_port` instance variables are set, they will be used for
        # the local host and port of the UDP connection.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #
        # @yieldparam [UDPsocket] socket
        #   The newly created UDPSocket object.
        #
        # @return [UDPSocket]
        #   The newly created UDPSocket object.
        #
        # @example
        #   udp_connect
        #   # => UDPSocket
        #
        # @example
        #   udp_connect do |sock|
        #     puts sock.readlines
        #   end
        #
        # @since 0.3.0
        #
        def udp_connect(&block)
          require_variable :host
          require_variable :port

          print_info "Connecting to #{@host}:#{@port} ..."

          return ::Net.udp_connect(@host,@port,@local_host,@local_port,&block)
        end

        #
        # Connects to the host and port specified by the `@host` and `@port`
        # instance variables, then sends the given data. If the
        # `@local_host` and `@local_port` instance variables are set, they
        # will be used for the local host and port of the UDP connection.
        #
        # @param [String] data
        #   The data to send through the connection.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #
        # @yieldparam [UDPsocket] socket
        #   The newly created UDPSocket object.
        #
        # @return [UDPSocket]
        #   The newly created UDPSocket object.
        #
        # @since 0.3.0
        #
        def udp_connect_and_send(data,&block)
          require_variable :host
          require_variable :port

          print_info "Connecting to #{@host}:#{@port} ..."
          print_debug "Sending data: #{data.inspect}"

          return ::Net.udp_connect_and_send(data,@host,@port,@local_host,@local_port,&block)
        end

        #
        # Creates a UDP session to the host and port specified by the
        # `@host` and `@port` instance variables. If the `@local_host` and
        # `@local_port` instance variables are set, they will be used for
        # the local host and port of the UDP connection.
        #
        # @yield [socket]
        #   If a block is given, it will be passed the newly created socket.
        #   After the block has returned, the socket will then be closed.
        #
        # @yieldparam [UDPsocket] socket
        #   The newly created UDPSocket object.
        #
        # @return [nil]
        #
        # @since 0.3.0
        #
        def udp_session(&block)
          require_variable :host
          require_variable :port

          print_info "Connecting to #{@host}:#{@port} ..."

          ::Net.udp_session(@host,@port,@local_host,@local_port,&block)

          print_info "Disconnected from #{@host}:#{@port}"
          return nil
        end

        #
        # Creates a new UDPServer object listening on `@server_host` and
        # `@server_port` instance variables.
        #
        # @yield [server]
        #   The given block will be passed the newly created server.
        #
        # @yieldparam [UDPServer] server
        #   The newly created server.
        #
        # @return [UDPServer]
        #   The newly created server.
        #
        # @example
        #   udp_server
        #
        # @since 0.3.0
        #
        def udp_server(&block)
          require_variable :server_port

          if @server_host
            print_info "Listening on #{@server_host}:#{@server_port} ..."
          else
            print_info "Listening on #{@server_port} ..."
          end

          return ::Net.udp_server(@server_port,@server_host,&block)
        end

        #
        # Creates a new temporary UDPServer object listening on the
        # `@server_host` and `@server_port` instance variables.
        #
        # @yield [server]
        #   The given block will be passed the newly created server.
        #   When the block has finished, the server will be closed.
        #
        # @yieldparam [UDPServer] server
        #   The newly created server.
        #
        # @return [nil]
        #
        # @example
        #   udp_server_session do |server|
        #     data, sender = server.recvfrom(1024)
        #   end
        #
        # @since 0.3.0
        #
        def udp_server_session(&block)
          require_variable :server_port

          if @server_host
            print_info "Listening on #{@server_host}:#{@server_port} ..."
          else
            print_info "Listening on #{@server_port} ..."
          end

          ::Net.udp_server_session(&block)

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
end

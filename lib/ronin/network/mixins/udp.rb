#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin.
#
# Ronin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ronin.  If not, see <http://www.gnu.org/licenses/>.
#

require 'ronin/network/mixins/mixin'
require 'ronin/network/udp'

module Ronin
  module Network
    module Mixins
      #
      # Adds UDP convenience methods and connection parameters to a class.
      #
      module UDP
        include Mixin

        # UDP host
        parameter :host,
                  :type => String,
                  :description => 'UDP host'

        # UDP port
        parameter :port,
                  :type => Integer,
                  :description => 'UDP port'

        # UDP local host
        parameter :local_host,
                  :type => String,
                  :description => 'UDP local host'

        # UDP local port
        parameter :local_port,
                  :type => Integer,
                  :description => 'UDP local port'

        # UDP server host
        parameter :server_host,
                  :type => String,
                  :description => 'UDP server host'

        # UDP server port
        parameter :server_port,
                  :type => Integer,
                  :description => 'UDP server port'

        protected

        #
        # Opens a UDP connection to the host and port specified by the
        # {#host} and {#port} parameters. If the {#local_host} and
        # {#local_port} parameters are set, they will be used for
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
        def udp_connect(&block)
          print_info "Connecting to #{self.host}:#{self.port} ..."

          return ::Net.udp_connect(self.host,self.port,self.local_host,self.local_port,&block)
        end

        #
        # Connects to the host and port specified by the {#host} and {#port}
        # parameters, then sends the given data. If the {#local_host} and
        # {#local_port} instance methods are set, they will be used for the
        # local host and port of the UDP connection.
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
        def udp_connect_and_send(data,&block)
          print_info "Connecting to #{self.host}:#{self.port} ..."
          print_debug "Sending data: #{data.inspect}"

          return ::Net.udp_connect_and_send(data,self.host,self.port,self.local_host,self.local_port,&block)
        end

        #
        # Creates a UDP session to the host and port specified by the
        # {#host} and {#port} parameters. If the {#local_host} and {#local_port}
        # parameters are set, they will be used for the local host and port
        # of the UDP connection.
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
        def udp_session(&block)
          print_info "Connecting to #{self.host}:#{self.port} ..."

          ::Net.udp_session(self.host,self.port,self.local_host,self.local_port,&block)

          print_info "Disconnected from #{self.host}:#{self.port}"
          return nil
        end

        #
        # Creates a new UDPServer object listening on {#server_host} and
        # {#server_port} parameters.
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
        def udp_server(&block)
          if self.server_host
            print_info "Listening on #{self.server_host}:#{self.server_port} ..."
          else
            print_info "Listening on #{self.server_port} ..."
          end

          return ::Net.udp_server(self.server_port,self.server_host,&block)
        end

        #
        # Creates a new temporary UDPServer object listening on the
        # {#server_host} and {#server_port} parameters.
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
        def udp_server_session(&block)
          if self.server_host
            print_info "Listening on #{self.server_host}:#{self.server_port} ..."
          else
            print_info "Listening on #{self.server_port} ..."
          end

          ::Net.udp_server_session(&block)

          if self.server_host
            print_info "Closed #{self.server_host}:#{self.server_port}"
          else
            print_info "Closed #{self.server_port}"
          end

          return nil
        end
      end
    end
  end
end

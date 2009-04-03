#
#--
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
#++
#

require 'ronin/network/tcp'

module Ronin
  module Sessions
    module TCP
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
        unless @host
        end
        
        unless @port
        end

        return ::Net.tcp_connect(@host,@port,@local_host,@local_port,&block)
      end

      #
      # Connects to the host and port specified by the +host+ and +port+
      # parameters, then sends the specified _data_. If a _block_ is given,
      # it will be passed the newly created TCPSocket object.
      #
      def tcp_connect_and_send(data,&block)
        unless @host
        end
        
        unless @port
        end

        return ::Net.tcp_connect_and_send(data,@host,@port,@local_host,@local_port,&block)
      end

      #
      # Creates a TCP session to the host and port specified by the
      # +host+ and +port+ parameters. If a _block_ is given, it will be
      # passed the temporary TCPSocket object. After the given _block_
      # has returned, the TCPSocket object will be closed.
      #
      def tcp_session(&block)
        unless @host
        end
        
        unless @port
        end

        return Net.tcp_session(@host,@port,@local_host,@local_port,&block)
      end

      #
      # Connects to the host and port specified by the +host+ and +port+
      # parameters, reads the banner then closes the connection, returning
      # the banner String. If a _block_ is given, it will be passed the
      # banner String.
      #
      def tcp_banner(&block)
        unless @host
        end
        
        unless @port
        end

        return ::Net.tcp_banner(@host,@port,@local_host,@local_port,&block)
      end

      #
      # Connects to the host and port specified by the +host+ and +port+
      # parameters, sends the specified _data_ and then closes the
      # connection. Returns +true+ if the data was successfully sent.
      #
      def tcp_send(data)
        unless @host
        end
        
        unless @port
        end

        return ::Net.tcp_send(data,@host,@port,@local_host,@local_port)
      end
    end
  end
end

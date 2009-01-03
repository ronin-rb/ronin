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

require 'ronin/sessions/session'
require 'ronin/network/udp'

module Ronin
  module Sessions
    module UDP
      include Session

      setup_session do
        parameter :local_host, :description => 'local host'
        parameter :local_port, :description => 'local port'

        parameter :host, :description => 'remote host'
        parameter :port, :description => 'remote port'
      end

      protected

      #
      # Opens a UDP connection to the host and port specified by the
      # +host+ and +port+ parameters. If the +local_host+ and +local_port+
      # parameters are set, they will be used for the local host and port
      # of the UDP connection. A UDPSocket object will be returned.
      #
      def udp_connect(&block)
        require_params :host, :port

        return ::Net.udp_connect(@host,@port,@local_host,@local_port,&block)
      end

      #
      # Connects to the host and port specified by the +host+ and +port+
      # parameters, then sends the specified _data_. If a _block_ is given,
      # it will be passed the newly created UDPSocket object.
      #
      def udp_connect_and_send(data,&block)
        require_params :host, :port

        return ::Net.udp_connect_and_send(data,@host,@port,@local_host,@local_port,&block)
      end

      #
      # Creates a UDP session to the host and port specified by the
      # +host+ and +port+ parameters. If a _block_ is given, it will be
      # passed the temporary UDPSocket object. After the given _block_
      # has returned, the UDPSocket object will be closed.
      #
      def udp_session(&block)
        require_params :host, :port

        return ::Net.udp_session(@host,@port,@local_host,@local_port,&block)
      end
    end
  end
end

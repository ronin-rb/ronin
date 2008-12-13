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

require 'ronin/sessions/session'
require 'ronin/network/tcp'

module Ronin
  module Sessions
    module TCP
      include Session

      setup_session do
        parameter :lhost, :description => 'TCP local host'
        parameter :lport, :description => 'TCP local port'

        parameter :rhost, :description => 'TCP remote host'
        parameter :rport, :description => 'TCP remote port'
      end

      protected

      #
      # Opens a TCP connection to the host and port specified by the
      # +rhost+ and +rport+ parameters. If the +lhost+ and +lport+
      # parameters are set, they will be used for the local host and port
      # of the TCP connection. A TCPSocket object will be returned. If
      # a _block_ is given, it will be passed the newly created TCPSocket
      # object.
      #
      def tcp_connect(&block)
        unless @rhost
          raise(ParamNotFound,"Missing parameter '#{describe_param(:rhost)}'",caller)
        end

        unless @rport
          raise(ParamNotFound,"Missing parameter '#{describe_param(:rport)}'",caller)
        end

        return ::Net.tcp_connect(@rhost,@rport,@lhost,@lport,&block)
      end

      #
      # Connects to the host and port specified by the +rhost+ and +rport+
      # parameters, then sends the specified _data_. If a _block_ is given,
      # it will be passed the newly created TCPSocket object.
      #
      def tcp_connect_and_send(data,&block)
        unless @rhost
          raise(ParamNotFound,"Missing parameter '#{describe_param(:rhost)}'",caller)
        end

        unless @rport
          raise(ParamNotFound,"Missing parameter '#{describe_param(:rport)}'",caller)
        end

        return ::Net.tcp_connect_and_send(data,@rhost,@rport,@lhost,@lport,&block)
      end

      #
      # Creates a TCP session to the host and port specified by the
      # +rhost+ and +rport+ parameters. If a _block_ is given, it will be
      # passed the temporary TCPSocket object. After the given _block_
      # has returned, the TCPSocket object will be closed.
      #
      def tcp_session(&block)
        unless @rhost
          raise(ParamNotFound,"Missing parameter '#{describe_param(:rhost)}'",caller)
        end

        unless @rport
          raise(ParamNotFound,"Missing parameter '#{describe_param(:rport)}'",caller)
        end

        return Net.tcp_session(@rhost,@rport,@lhost,@lport,&block)
      end

      #
      # Connects to the host and port specified by the +rhost+ and +rport+
      # parameters, reads the banner then closes the connection, returning
      # the banner String. If a _block_ is given, it will be passed the
      # banner String.
      #
      def tcp_banner(&block)
        unless @rhost
          raise(ParamNotFound,"Missing parameter '#{describe_param(:rhost)}'",caller)
        end

        unless @rport
          raise(ParamNotFound,"Missing parameter '#{describe_param(:rport)}'",caller)
        end

        return ::Net.tcp_banner(@rhost,@rport,@lhost,@lport,&block)
      end
    end
  end
end

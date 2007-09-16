#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'ronin/parameters'
require 'ronin/parameters/exceptions/paramnotfound'

require 'socket'

module Ronin
  module Proto
    module TCP
      include Parameters

      def self.included(klass)
        klass.module_eval do
          parameter :lhost, :description => 'local host'
          parameter :lport, :description => 'local port'

          parameter :rhost, :description => 'remote host'
          parameter :rport, :description => 'remote port'
        end
      end

      def self.extended(obj)
        obj.instance_eval do
          parameter :lhost, :description => 'local host'
          parameter :lport, :description => 'local port'

          parameter :rhost, :description => 'remote host'
          parameter :rport, :description => 'remote port'
        end
      end

      protected

      def tcp_connect(&block)
        unless @rhost
          raise(ParamNotFound,"Missing '#{describe_param(:rhost)}' parameter",caller)
        end

        unless @rport
          raise(ParamNotFound,"Missing '#{describe_param(:rport)}' parameter",caller)
        end

        return TCPSocket.new(@rhost,@rport,&block)
      end

      def tcp_listen(&block)
        # TODO: implement some sort of basic tcp server
      end
    end
  end
end

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
require 'ronin/network/telnet'

module Ronin
  module Sessions
    module TELNET
      include Session

      setup_session do
        parameter :telnet_host, :description => 'Telnet host'
        parameter :telnet_port,
                  :value => Network::Telnet.default_port,
                  :description => 'Telnet port'

        parameter :telnet_user, :description => 'Telnet user'
        parameter :telnet_password, :description => 'Telnet password'

        parameter :telnet_proxy, :description => 'Telnet proxy'
        parameter :telnet_ssl, :description => 'Telnet SSL options'
      end

      protected

      def telnet_connect(options={},&block)
        unless @telnet_host
          raise(ParamNotFound,"Missing parameter '#{describe_param(:telnet_host)}'",caller)
        end

        options[:port] ||= @telnet_port
        options[:user] ||= @telnet_user
        options[:password] ||= @telnet_password

        options[:proxy] ||= @telnet_proxy
        options[:ssl] ||= @telnet_ssl

        return ::Net.telnet_connect(@telnet_host,options,&block)
      end

      def telnet_session(options={},&block)
        return telnet_connect(options) do |sess|
          block.call(sess) if block
          sess.close
        end
      end
    end
  end
end

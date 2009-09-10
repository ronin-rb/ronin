#
# Ronin - A Ruby platform for exploit development and security research.
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

require 'ronin/network/helpers/helper'
require 'ronin/network/pop3'

module Ronin
  module Network
    module Helpers
      module POP3
        include Helper

        protected

        #
        # Creates a connection to the POP3 server. The +@host+, +@port+,
        # +@pop3_user+ and +@pop3_password+ instance variables will also
        # be used to connect to the server.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port (Ronin::Network::POP3.default_port)
        #   The port the POP3 server is running on.
        #
        # @option options [String] :user
        #   The user to authenticate with when connecting to the POP3
        #   server.
        #
        # @option options [String] :password
        #   The password to authenticate with when connecting to the POP3
        #   server.
        #
        # @yield [session]
        #   If a _block_ is given, it will be passed the newly created
        #   POP3 session.
        #
        # @yieldparam [Net::POP3] session
        #   The newly created POP3 session.
        #
        # @return [Net::POP3]
        #   The newly created POP3 session.
        #
        # @since 0.3.0
        #
        def pop3_connect(options={},&block)
          require_variable :host

          options[:port] ||= @port
          options[:user] ||= @pop3_user
          options[:password] ||= @pop3_password

          if @port
            print_info "Connecting to #{@host}:#{@port} ..."
          else
            print_info "Connecting to #{@host} ..."
          end

          return ::Net.pop3_connect(@host,options,&block)
        end

        #
        # Starts a session with the POP3 server. The +@host+, +@port+,
        # +@pop3_user+ and +@pop3_password+ instance variables will
        # also be used to connect to the server.
        #
        # @yield [session]
        #   If a _block_ is given, it will be passed the newly created
        #   POP3 session. After the _block_ has returned, the session
        #   will be closed.
        #
        # @yieldparam [Net::POP3] session
        #   The newly created POP3 session.
        #
        # @see pop3_connect
        # @since 0.3.0
        #
        def pop3_session(options={},&block)
          pop3_connect(options) do |sess|
            block.call(sess) if block
            sess.finish

            if @port
              print_info "Disconnecting to #{@host}:#{@port}"
            else
              print_info "Disconnecting to #{@host}"
            end
          end
        end
      end
    end
  end
end

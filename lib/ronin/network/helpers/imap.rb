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
require 'ronin/network/imap'

module Ronin
  module Network
    module Helpers
      module IMAP
        include Helper

        protected

        #
        # Creates a connection to the IMAP server. The +@host+, +@port+,
        # +@imap_auth+, +@imap_user+ and +@imap_password+ instance
        # variables will also be used to make the connection.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port (IMAP.default_port)
        #   The port the IMAP server is running on.
        #
        # @option options [String] :certs
        #   The path to the file containing CA certs of the server.
        #
        # @option options [Symbol] :auth
        #   The type of authentication to perform when connecting to the
        #   server. May be either +:login+ or +:cram_md5+.
        #
        # @option options [String] :user
        #   The user to authenticate as when connecting to the server.
        #
        # @option options [String] :password
        #   The password to authenticate with when connecting to the
        #   server.
        #
        # @option options [Boolean]
        #   Indicates wether or not to use SSL when connecting to the
        #   server.
        #
        # @since 0.3.0
        #
        def imap_connect(options={},&block)
          require_variable :host

          options[:port] ||= @port
          options[:auth] ||= @imap_auth
          options[:user] ||= @imap_user
          options[:password] ||= @imap_password

          if @port
            print_info "Connecting to #{@host}:#{@port} ..."
          else
            print_info "Connecting to #{@host} ..."
          end

          return ::Net.imap_connect(@host,options,&block)
        end

        #
        # Starts a session with the IMAP server. The +@host+, +@port+,
        # +@imap_auth+, +@imap_user+ and +@imap_password+ instance
        # variables will also be used to make the connection.
        #
        # @yield [session]
        #   If a _block_ is given, it will be passed the newly created
        #   IMAP session. After the _block_ has returned, the session will
        #   be closed.
        #
        # @yieldparam [Net::IMAP] session
        #   The newly created IMAP session object.
        #
        # @see imap_connect
        # @since 0.3.0
        #
        def imap_session(options={},&block)
          imap_connect(options) do |sess|
            block.call(sess) if block

            print_info "Logging out ..."

            sess.close
            sess.logout

            if @port
              print_info "Disconnecting from #{@host}:#{@port}"
            else
              print_info "Disconnecting from #{@host}"
            end
          end
        end
      end
    end
  end
end

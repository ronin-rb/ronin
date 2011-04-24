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

require 'ronin/network/imap'
require 'ronin/ui/output/helpers'
require 'ronin/mixin'

require 'parameters'

module Ronin
  module Network
    module Mixins
      #
      # Adds IMAP convenience methods and connection parameters to a class.
      #
      module IMAP
        include Mixin

        mixin UI::Output::Helpers, Parameters

        mixin do
          # IMAP host
          parameter :host, :type => String,
                           :description => 'IMAP host'

          # IMAP port
          parameter :port, :type => Integer,
                           :description => 'IMAP port'

          # IMAP auth
          parameter :imap_auth, :type => String,
                                :description => 'IMAP authentication method'

          # IMAP user to login as
          parameter :imap_user, :type => String,
                                :description => 'IMAP user to login as'

          # IMAP password to login with
          parameter :imap_password, :type => String,
                                    :description => 'IMAP password to login with'
        end

        protected

        #
        # Creates a connection to the IMAP server. The `host`, `port`,
        # `imap_auth`, `imap_user` and `imap_password` parameters
        # will also be used to make the connection.
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
        #   server. May be either `:login` or `:cram_md5`.
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
        def imap_connect(options={},&block)
          options[:port] ||= self.port
          options[:auth] ||= self.imap_auth
          options[:user] ||= self.imap_user
          options[:password] ||= self.imap_password

          if self.port
            print_info "Connecting to #{self.host}:#{self.port} ..."
          else
            print_info "Connecting to #{self.host} ..."
          end

          return ::Net.imap_connect(self.host,options,&block)
        end

        #
        # Starts a session with the IMAP server. The `host`, `port`,
        # `imap_auth`, `imap_user` and `imap_password` parameters
        # will also be used to make the connection.
        #
        # @yield [session]
        #   If a block is given, it will be passed the newly created
        #   IMAP session. After the block has returned, the session will
        #   be closed.
        #
        # @yieldparam [Net::IMAP] session
        #   The newly created IMAP session object.
        #
        # @see imap_connect
        #
        def imap_session(options={})
          imap_connect(options) do |sess|
            yield sess if block_given?

            print_info "Logging out ..."

            sess.close
            sess.logout

            if self.port
              print_info "Disconnecting from #{self.host}:#{self.port}"
            else
              print_info "Disconnecting from #{self.host}"
            end
          end
        end
      end
    end
  end
end

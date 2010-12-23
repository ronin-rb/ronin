#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA  02110-1301  USA
#

require 'ronin/network/esmtp'

require 'parameters'

module Ronin
  module Network
    module Mixins
      #
      # Adds ESMTP convenience methods and connection parameters to a class.
      #
      module ESMTP
        include Parameters

        # ESMTP host
        parameter :host,
                  :type => String,
                  :description => 'ESMTP host'

        # ESMTP port
        parameter :port,
                  :type => Integer,
                  :description => 'ESMTP port'

        # ESMTP authentication method to use
        parameter :esmtp_login,
                  :type => String,
                  :description => 'ESMTP authentication method to use'

        # ESMTP user to login as
        parameter :esmtp_user,
                  :type => String,
                  :description => 'ESMTP user to login as'

        # ESMTP password to login with
        parameter :esmtp_password,
                  :type => String,
                  :description => 'ESMTP password to login with'

        protected

        #
        # @see Ronin::Network::SMTP.message.
        #
        def esmtp_message(options={},&block)
          Network::SMTP.message(options,&block)
        end

        #
        # Creates a connection to the ESMTP server. The {#host}, {#port},
        # {#esmtp_login}, {#esmtp_user} and {#esmtp_password} parameters
        # will also be used to connect to the ESMTP server.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port (Ronin::Network::SMTP.default_port)
        #  The port to connect to.
        #
        # @option options [String] :helo
        #   The HELO domain.
        #
        # @option options [Symbol] :auth
        #   The type of authentication to use.
        #   Can be either `:login`, `:plain`, or `:cram_md5`.
        #
        # @option options [String] :user
        #   The user-name to authenticate with.
        #
        # @option options [String] :password
        #   The password to authenticate with.
        #
        # @yield [session]
        #   If a block is given, it will be passed an ESMTP enabled
        #   session object.
        #
        # @yieldparam [Net::SMTP] session
        #   The ESMTP session.
        #
        # @return [Net::SMTP]
        #   The ESMTP enabled session.
        #
        def esmtp_connect(options={},&block)
          options[:port] ||= self.port
          options[:login] ||= self.esmtp_login
          options[:user] ||= self.esmtp_user
          options[:password] ||= self.esmtp_password

          if self.port
            print_info "Connecting to #{self.host}:#{self.port} ..."
          else
            print_info "Connecting to #{self.host} ..."
          end

          return ::Net.esmtp_connect(self.host,options,&block)
        end

        #
        # Starts a session with the ESMTP server. The {#host}, {#port},
        # {#esmtp_login}, {#esmtp_user} and {#esmtp_password} parameters
        # will also be used to connect to the ESMTP server.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @yield [session]
        #   If a block is given, it will be passed an ESMTP enabled
        #   session object. After the block has returned, the session
        #   will be closed.
        #
        # @yieldparam [Net::SMTP] session
        #   The ESMTP session.
        #
        # @see esmtp_connect
        #
        def esmtp_session(options={})
          esmtp_connect(options) do |sess|
            yield sess if block_given?

            sess.close

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

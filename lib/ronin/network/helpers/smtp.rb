#
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
#

require 'ronin/network/helpers/helper'
require 'ronin/network/smtp'

module Ronin
  module Network
    module Helpers
      module SMTP
        include Helper

        protected

        #
        # @see Ronin::Network::SMTP.message
        #
        # @since 0.3.0
        #
        def smtp_message(options={},&block)
          Network::SMTP.message(options,&block)
        end

        #
        # Connects to the SMTP server using the given _options_. The
        # +@host+, +@port+, +@smtp_login+, +@smtp_user+ and +@smtp_password+
        # instance variables will also be used to connect to the server.
        #
        # @param [Hash] options Additional options.
        # @option options [Integer] :port (Ronin::Network::SMTP.default_port)
        #                                 The port to connect to.
        # @option options [String] :helo The HELO domain.
        # @option options [Symbol] :auth The type of authentication to use.
        #                                Can be either +:login+, +:plain+,
        #                                or +:cram_md5+.
        # @option options [String] :user The user-name to authenticate with.
        # @option options [String] :password The password to authenticate
        #                                    with.
        #
        # @yield [session] If a block is given, it will be passed an SMTP
        #                  session object.
        # @yieldparam [Net::SMTP] session The SMTP session.
        # @return [Net::SMTP] the SMTP session.
        #
        # @since 0.3.0
        #
        def smtp_connect(options={},&block)
          require_variable :host

          options[:port] ||= @port
          options[:login] ||= @smtp_login
          options[:user] ||= @smtp_user
          options[:password] ||= @smtp_password

          if @port
            print_info "Connecting to #{@host}:#{@port} ..."
          else
            print_info "Connecting to #{@host} ..."
          end

          return ::Net.smtp_connect(@host,options,&block)
        end

        #
        # Connects to the SMTP server using the given _options_. The
        # +@host+, +@port+, +@smtp_login+, +@smtp_user+ and +@smtp_password+
        # instance variables will also be used to connect to the server.
        #
        # @yield [session] If a block is given, it will be passed an SMTP
        #                  session object. After the block has returned, the
        #                  session will be closed.
        # @yieldparam [Net::SMTP] session The SMTP session.
        #
        # @see smtp_connect
        # @since 0.3.0
        #
        def smtp_session(options={},&block)
          smtp_connect(options) do |sess|
            block.call(sess) if block
            sess.close

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

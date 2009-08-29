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
require 'ronin/network/telnet'

module Ronin
  module Network
    module Helpers
      module Telnet
        include Helper

        protected

        #
        # Creates a connection to a Telnet server. The +@host+, +@port+,
        # +@telnet_user+, +@telnet_password+, +@telnet_proxy+ and
        # +@telnet_ssl+ instance variables will also be used to connect
        # to the Telnet server.
        #
        # @param [Hash] options Additional options.
        # @option options [Integer] :port (Ronin::Network::Telnet.default_port)
        #                                 The port to connect to.
        # @option options [true, false] :binmode Indicates that newline
        #                                        substitution shall not be
        #                                        performed.
        # @option options [String] :output_log The name of the file to write
        #                                      connection status messages
        #                                      and all received traffic to.
        # @option options [String] :dump_log Similar to the +:output_log+
        #                                    option, but connection output
        #                                    is also written in hexdump
        #                                    format.
        # @option options [Regexp] :prompt (Ronin::Network::Telnet.default_prompt)
        #                                  A regular expression matching the
        #                                  host command-line prompt
        #                                  sequence, used to determine when
        #                                  a command has finished.
        # @option options [true, false] :telnet (true)
        #                                       Indicates that the
        #                                       connection shall behave as
        #                                       a telnet connection.
        # @option options [true, false] :plain Indicates that the connection
        #                                      shall behave as a normal TCP
        #                                      connection.
        # @option options [Integer] :timeout (Ronin::Network::Telnet.default_timeout)
        #                                    The number of seconds to wait
        #                                    before timing out both the
        #                                    initial attempt to connect to
        #                                    host, and all attempts to read
        #                                    data from the host.
        # @option options [Integer] :wait_time The amount of time to wait
        #                                      after seeing what looks like
        #                                      a prompt.
        # @option options [Net::Telnet, IO] :proxy (Ronin::Network::Telnet.proxy)
        #                                    A proxy object to used instead
        #                                    of opening a direct connection
        #                                    to the host.
        # @option options [String] :user The user to login as.
        # @option options [String] :password The password to login with.
        # @yield [connection] If a block is given, it will be passed the
        #                     newly created Telnet connection.
        # @yieldparam [Net::Telnet] connection The newly created Telnet
        #                                      connection.
        # @return [Net::Telnet] The Telnet session
        #
        # @example
        #   telnet_connect
        #   # => Net::Telnet
        #
        # @since 0.3.0
        #
        def telnet_connect(options={},&block)
          require_variable :host

          options[:port] ||= @port
          options[:user] ||= @telnet_user
          options[:password] ||= @telnet_password

          options[:proxy] ||= @telnet_proxy
          options[:ssl] ||= @telnet_ssl

          if @port
            print_info "Connecting to #{@host}:#{@port} ..."
          else
            print_info "Connecting to #{@host} ..."
          end

          return ::Net.telnet_connect(@host,options,&block)
        end

        #
        # Starts a session with a Telnet server. The +@host+, +@port+,
        # +@telnet_user+, +@telnet_password+, +@telnet_proxy+ and
        # +@telnet_ssl+ instance variables will also be used to connect
        # to the Telnet server.
        #
        # @yield [session] If a block is given, it will be passed the newly
        #                  created Telnet session. After the block has
        #                  returned, the Telnet session will be closed.
        # @yieldparam [Net::Telnet] session The newly created Telnet
        #                                   session.
        #
        # @example
        #   telnet_session do |movie|
        #     movie.each_line { |line| puts line }
        #   end
        #
        # @see telnet_connect
        # @since 0.3.0
        #
        def telnet_session(options={},&block)
          return telnet_connect(options) do |sess|
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

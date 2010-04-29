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

require 'ronin/network/telnet'

require 'parameters'

module Ronin
  module Network
    module Mixins
      #
      # Adds Telnet convenience methods and connection parameters to a
      # class.
      #
      module Telnet
        include Parameters

        # Telnet host
        parameter :host,
                  :type => String,
                  :description => 'Telnet host'

        # Telnet port
        parameter :port,
                  :type => Integer,
                  :description => 'Telnet port'

        # Telnet user
        parameter :telnet_user,
                  :type => String,
                  :description => 'Telnet user to login as'

        # Telnet password
        parameter :telnet_password,
                  :type => String,
                  :description => 'Telnet password to login with'

        # Telnet proxy
        parameter :telnet_proxy,
                  :description => 'Telnet proxy'

        # Enable Telnet SSL
        parameter :telnet_ssl,
                  :type => true,
                  :description => 'Enable Telnet over SSL'

        protected

        #
        # Creates a connection to a Telnet server. The {host}, {port},
        # {telnet_user}, {telnet_password}, {telnet_proxy} and
        # {telnet_ssl} parameters will also be used to connect to the
        # Telnet server.
        #
        # @param [Hash] options
        #   Additional options.
        #
        # @option options [Integer] :port (Ronin::Network::Telnet.default_port)
        #   The port to connect to.
        #
        # @option options [Boolean] :binmode
        #   Indicates that newline substitution shall not be performed.
        #
        # @option options [String] :output_log
        #   The name of the file to write connection status messages
        #   and all received traffic to.
        #
        # @option options [String] :dump_log
        #   Similar to the `:output_log` option, but connection output
        #   is also written in hexdump format.
        #
        # @option options [Regexp] :prompt (Ronin::Network::Telnet.default_prompt)
        #   A regular expression matching the host command-line prompt
        #   sequence, used to determine when a command has finished.
        #
        # @option options [Boolean] :telnet (true)
        #   Indicates that the connection shall behave as a telnet
        #   connection.
        #
        # @option options [Boolean] :plain
        #   Indicates that the connection shall behave as a normal TCP
        #   connection.
        #
        # @option options [Integer] :timeout (Ronin::Network::Telnet.default_timeout)
        #   The number of seconds to wait before timing out both the
        #   initial attempt to connect to host, and all attempts to read
        #   data from the host.
        #
        # @option options [Integer] :wait_time
        #   The amount of time to wait after seeing what looks like
        #   a prompt.
        #
        # @option options [Net::Telnet, IO] :proxy (Ronin::Network::Telnet.proxy)
        #   A proxy object to used instead of opening a direct connection
        #   to the host.
        #
        # @option options [String] :user
        #   The user to login as.
        #
        # @option options [String] :password
        #   The password to login with.
        #
        # @yield [connection]
        #   If a block is given, it will be passed the newly created
        #   Telnet connection.
        #
        # @yieldparam [Net::Telnet] connection
        #   The newly created Telnet connection.
        #
        # @return [Net::Telnet]
        #   The Telnet session
        #
        # @example
        #   telnet_connect
        #   # => Net::Telnet
        #
        def telnet_connect(options={},&block)
          options[:port] ||= self.port
          options[:user] ||= self.telnet_user
          options[:password] ||= self.telnet_password

          options[:proxy] ||= self.telnet_proxy
          options[:ssl] ||= self.telnet_ssl

          if self.port
            print_info "Connecting to #{self.host}:#{self.port} ..."
          else
            print_info "Connecting to #{self.host} ..."
          end

          return ::Net.telnet_connect(self.host,options,&block)
        end

        #
        # Starts a session with a Telnet server. The {host}, {port},
        # {telnet_user}, {telnet_password}, {telnet_proxy} and
        # {telnet_ssl} parameters will also be used to connect to the
        # Telnet server.
        #
        # @yield [session]
        #   If a block is given, it will be passed the newly created
        #   Telnet session. After the block has returned, the Telnet
        #   session will be closed.
        #
        # @yieldparam [Net::Telnet] session
        #   The newly created Telnet session.
        #
        # @example
        #   telnet_session do |movie|
        #     movie.each_line { |line| puts line }
        #   end
        #
        # @see telnet_connect
        #
        def telnet_session(options={},&block)
          return telnet_connect(options) do |sess|
            block.call(sess) if block
            sess.close

            if self.port
              print_info "Disconnecting to #{self.host}:#{self.port}"
            else
              print_info "Disconnecting to #{self.host}"
            end
          end
        end
      end
    end
  end
end

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

module Ronin
  module Network
    module HTTP
      class Proxy < Hash

        # The default port of proxies
        DEFAULT_PORT = 8080

        #
        # Creates a new Proxy object that represents a proxy to connect to.
        #
        def initialize
          super(
            :host => nil,
            :port => DEFAULT_PORT,
            :user => nil,
            :password => nil
          )
        end

        #
        # Disables the Proxy object.
        #
        def disable!
          self[:host] = nil
          self[:port] = DEFAULT_PORT
          self[:user] = nil
          self[:password] = nil
          return self
        end

        #
        # Specifies whether the proxy object is usable.
        #
        # @return [true, false] Specifies whether the proxy object is
        #                       usable by Net::HTTP::Proxy.
        #
        def enabled?
          !(self[:host].nil? || self[:port].nil?)
        end

        #
        # @return [String, nil] The host-name to connect when using the
        #                       proxy.
        #
        def host
          self[:host]
        end

        #
        # Set the host-name of the proxy.
        #
        # @param [String] new_host The new host-name to use.
        # @return [String] The new host-name to use.
        #
        def host=(new_host)
          self[:host] = new_host.to_s
        end

        #
        # @return [Integer] The port to connect when using the proxy.
        #
        def port
          self[:port]
        end

        #
        # Set the port of the proxy.
        #
        # @param [Integer] new_port The new port to use.
        # @return [Integer] The new port to use.
        #
        def port=(new_port)
          self[:port] = new_port.to_i
        end

        #
        # @return [String, nil] The user-name to authenticate as, when
        #                       using the proxy.
        #
        def user
          self[:user]
        end

        #
        # Set the user-name to authenticate as with the proxy.
        #
        # @param [String] new_user The new user-name to use.
        # @return [Integer] The new user-name to use.
        #
        def user=(new_user)
          self[:user] = new_user.to_s
        end

        #
        # @return [String, nil] The password to authenticate with, when
        #                       using the proxy.
        #
        def password
          self[:password]
        end

        #
        # Set the password to authenticate with for the proxy.
        #
        # @param [String] new_user The new user-name to use.
        # @return [Integer] The new user-name to use.
        #
        def password=(new_password)
          self[:password] = new_password.to_s
        end

        #
        # Converts the proxy object to a String.
        #
        # @return [String] The host-name of the proxy.
        #
        def to_s
          self[:host].to_s
        end

        def inspect
          unless (self[:host] || self[:port])
            str = 'disabled'
          else
            str = "#{self[:host]}:#{self[:port]}"

            if self[:user]
              auth_str = self[:user]

              if self[:password]
                auth_str = "#{auth_str}:#{self[:password]}"
              end

              str = "#{auth_str}@#{str}"
            end
          end

          return "#<#{self.class}: #{str}>"
        end

      end
    end
  end
end

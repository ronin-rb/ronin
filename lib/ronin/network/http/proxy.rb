#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2006-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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
        # @param [Hash] options
        #   Additional options for the proxy.
        #
        # @option options [String] :host
        #   The host-name of the proxy.
        #
        # @option options [Integer] :port (DEFAULT_PORT)
        #   The port that the proxy is running on.
        # @option options [String] :user
        #   The user-name to authenticate as.
        # @option options [String] :password
        #   The password to authenticate with.
        #
        def initialize(options={})
          super()

          self[:host] = options[:host]
          self[:port] = (options[:port] || DEFAULT_PORT)
          self[:user] = options[:user]
          self[:password] = options[:password]
        end

        #
        # Parses a proxy URL.
        #
        # @param [String, URI::HTTP] proxy
        #   The proxy URL in String form.
        #
        # @return [Proxy]
        #   The parsed proxy information.
        #
        # @example
        #   Proxy.parse('217.31.51.77:443')
        #
        # @example
        #   Proxy.parse('joe:lol@127.0.0.1:8080')
        #
        # @example
        #   Proxy.parse('http://201.26.192.61:8080')
        #
        def Proxy.parse(proxy)
          proxy = proxy.to_s.gsub(/^http(s)?:\/*/,'')

          if proxy.include?('@')
            auth, proxy = proxy.split('@',2)
            user, password = auth.split(':')
          else
            user = nil
            password = nil
          end

          host, port = proxy.split(':',2)
          port = port.to_i if port

          return Proxy.new(
            :host => host,
            :port => port,
            :user => user,
            :password => password
          )
        end

        #
        # Tests the proxy.
        #
        # @return [Boolean]
        #   Specifies if the proxy can proxy requests.
        #
        def valid?
          begin
            Net.http_get_body(
              :url => 'http://www.example.com/',
              :proxy => self
            ).include?('Example Web Page')
          rescue Timeout::Error, StandardError
            return false
          end
        end

        #
        # Measures the lag of the proxy.
        #
        # @return [Float]
        #   The extra number of seconds it takes the proxy to process the
        #   request.
        #
        def lag
          time = lambda { |proxy|
            t1 = Time.now
            Net.http_head(
              :url => 'http://www.example.com/',
              :proxy => proxy
            )
            t2 = Time.now

            (t2 - t1)
          }

          begin
            return (time.call(self) - time.call(nil))
          rescue Timeout::Error, StandardError
            return (1.0/0)
          end
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
        # @return [Boolean]
        #   Specifies whether the proxy object is usable by
        #   Net::HTTP::Proxy.
        #
        def enabled?
          !(self[:host].nil? || self[:port].nil?)
        end

        #
        # @return [String, nil]
        #   The host-name to connect when using the proxy.
        #
        def host
          self[:host]
        end

        #
        # Set the host-name of the proxy.
        #
        # @param [String] new_host
        #   The new host-name to use.
        #
        # @return [String]
        #   The new host-name to use.
        #
        def host=(new_host)
          self[:host] = new_host.to_s
        end

        #
        # @return [Integer]
        #   The port to connect when using the proxy.
        #
        def port
          self[:port]
        end

        #
        # Set the port of the proxy.
        #
        # @param [Integer] new_port
        #   The new port to use.
        #
        # @return [Integer]
        #   The new port to use.
        #
        def port=(new_port)
          self[:port] = new_port.to_i
        end

        #
        # @return [String, nil]
        #   The user-name to authenticate as, when using the proxy.
        #
        def user
          self[:user]
        end

        #
        # Set the user-name to authenticate as with the proxy.
        #
        # @param [String] new_user
        #   The new user-name to use.
        #
        # @return [Integer]
        #   The new user-name to use.
        #
        def user=(new_user)
          self[:user] = new_user.to_s
        end

        #
        # @return [String, nil]
        #   The password to authenticate with, when using the proxy.
        #
        def password
          self[:password]
        end

        #
        # Set the password to authenticate with for the proxy.
        #
        # @param [String] new_user
        #   The new user-name to use.
        #
        # @return [Integer]
        #   The new user-name to use.
        #
        def password=(new_password)
          self[:password] = new_password.to_s
        end

        #
        # Builds a HTTP URI from the proxy information.
        #
        # @return [URI::HTTP, nil]
        #   The HTTP URI representing the proxy. If the proxy is disabled,
        #   then `nil` will be returned.
        #
        def url
          return nil unless enabled?

          userinfo = if self[:user]
                       if self[:password]
                         "#{self[:user]}:#{self[:password]}"
                       else
                         self[:user]
                       end
                     end
          
          return URI::HTTP.build({
            :userinfo => userinfo,
            :host => self[:host],
            :port => self[:port]
          })
        end

        #
        # Converts the proxy object to a String.
        #
        # @return [String]
        #   The host-name of the proxy.
        #
        def to_s
          self[:host].to_s
        end

        #
        # Inspects the proxy object.
        #
        # @return [String]
        #   The inspection of the proxy object.
        #
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

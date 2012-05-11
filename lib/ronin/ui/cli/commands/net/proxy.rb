#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/ui/cli/command'
require 'ronin/network/tcp/proxy'
require 'ronin/network/udp/proxy'

require 'hexdump/dumper'

module Ronin
  module UI
    module CLI
      module Commands
        module Net
          class Proxy < Command

            summary 'Starts a TCP/UDP intercept proxy'

            option :tcp, :type        => true,
                         :default     => true,
                         :flag        => '-t',
                         :description => 'TCP Proxy'

            option :udp, :type        => true,
                         :flag        => '-u',
                         :description => 'UDP Proxy'

            option :hexdump, :type        => true,
                             :flag        => '-x',
                             :description => 'Enable hexdump output'

            option :host, :type        => String,
                          :default     => '0.0.0.0',
                          :flag        => '-H',
                          :usage       => 'HOST',
                          :description => 'Host to listen on'

            option :port, :type        => Integer,
                          :flag        => '-p',
                          :usage       => 'PORT',
                          :description => 'Port to listen on'

            option :server, :type        => String,
                            :flag        => '-s',
                            :usage       => 'HOST[:PORT]',
                            :description => 'Server to forward connections to'

            def setup
              super

              @server_host, @server_port = server.split(':',2)
              @server_port = if @server_port
                               @server_port.to_i
                             else
                               @port
                             end

              @hexdumper = Hexdump::Dumper.new
            end

            def execute
              proxy = proxy_class.new(
                :port   => @port,
                :host   => @host,
                :server => [@server_host, @server_port]
              )

              if tcp?
                proxy.on_client_connect do |client|
                  print_outgoing client, server, '[connected]'
                end

                proxy.on_client_disconnect do |client,server|
                  print_outgoing client, server, '[disconnected]'
                end

                proxy.on_server_connect do |client,server|
                  print_incoming client, server, '[connected]'
                end

                proxy.on_server_disconnect do |client,server|
                  print_incoming client, server, '[disconnected]'
                end
              end

              proxy.on_client_data do |client,server,data|
                print_outgoing client, server
                print_data data
              end

              proxy.on_server_data do |client,server,data|
                print_incoming client, server
                print_data data
              end

              proxy.on_data do |client,server,data|
              end

              proxy.start
            end

            protected

            def proxy_class
              if udp?
                Network::UDP::Proxy
              elsif tcp?
                Network::TCP::Proxy
              end
            end

            def address(connection)
              case connection
              when Array
                socket, (host, port) = connection

                "#{host}:#{port}"
              when TCPSocket, UDPSocket
                addrinfo = connection.peeraddr

                "#{addrinfo[3]}:#{addrinfo[1]}"
              when nil
                "#{@server_host}:#{@server_port}"
              end
            end

            def print_incoming(client,server,type=nil)
              print_info "#{address(client)} <- #{address(server)} #{type}"
            end

            def print_outgoing(client,server,type=nil)
              print_info "#{address(client)} -> #{address(server)} #{type}"
            end

            def print_data(data)
              if hexdump?
                @hexdumper.dump(data)
              else
                puts data
              end
            end

          end
        end
      end
    end
  end
end

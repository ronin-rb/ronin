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
                          :default     => Network::Proxy::DEFAULT_HOST,
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

            option :rewrite_client, :type        => Hash[String => String],
                                    :usage       => 'STRING:REPLACE',
                                    :description => 'Client rewrite rules'

            option :rewrite_server, :type        => Hash[String => String],
                                    :usage       => 'STRING:REPLACE',
                                    :description => 'Server rewrite rules'

            option :rewrite, :type        => Hash[String => String],
                             :flag        => '-r',
                             :usage       => 'STRING:REPLACE',
                             :description => 'Rewrite rules'

            option :ignore_client, :type        => Set[String],
                                   :usage       => 'STRING [...]',
                                   :description => 'Client ignore rules'

            option :ignore_server, :type        => Set[String],
                                   :usage       => 'STRING [...]',
                                   :description => 'Server ignore rules'

            option :ignore, :type        => Set[String],
                            :flag        => '-i',
                            :usage       => 'STRING [...]',
                            :description => 'Ignore rules'

            option :close_client, :type        => Set[String],
                                  :usage       => 'STRING [...]',
                                  :description => 'Client close rules'

            option :close_server, :type        => Set[String],
                                  :usage       => 'STRING [...]',
                                  :description => 'Server close rules'

            option :close, :type        => Set[String],
                           :flag        => '-C',
                           :usage       => 'STRING [...]',
                           :description => 'Close rules'

            option :reset_client, :type        => Set[String],
                                  :usage       => 'STRING [...]',
                                  :description => 'Client reset rules'

            option :reset_server, :type        => Set[String],
                                  :usage       => 'STRING [...]',
                                  :description => 'Server reset rules'

            option :reset, :type        => Set[String],
                           :flag        => '-R',
                           :usage       => 'STRING [...]',
                           :description => 'Reset rules'

            def setup
              super

              @server_host, @server_port = server.split(':',2)
              @server_port = if @server_port
                               @server_port.to_i
                             else
                               @port
                             end

              if hexdump?
                @hexdumper = Hexdump::Dumper.new
              end
            end

            def execute
              @proxy = proxy_class.new(
                :port   => @port,
                :host   => @host,
                :server => [@server_host, @server_port]
              )

              if tcp?
                @proxy.on_client_connect do |client|
                  print_outgoing client, '[connecting]'
                end

                @proxy.on_client_disconnect do |client,server|
                  print_outgoing client, '[disconnecting]'
                end

                @proxy.on_server_connect do |client,server|
                  print_incoming client, '[connected]'
                end

                @proxy.on_server_disconnect do |client,server|
                  print_incoming client, '[disconnected]'
                end
              end

              if @reset_client
                @reset_client.each do |string|
                  @proxy.on_client_data do |client,server,data|
                    @proxy.reset! if data.include?(string)
                  end
                end
              end

              if @close_client
                @close_client.each do |string|
                  @proxy.on_client_data do |client,server,data|
                    @proxy.close! if data.include?(string)
                  end
                end
              end

              if @ignore_client
                @ignore_client.each do |string|
                  @proxy.on_client_data do |client,server,data|
                    @proxy.ignore! if data.include?(string)
                  end
                end
              end

              if @rewrite_client
                @rewrite_client.each do |string,replace|
                  @proxy.on_client_data do |client,server,data|
                    data.gsub!(string,replace)
                  end
                end
              end

              if @reset_server
                @reset_server.each do |string|
                  @proxy.on_server_data do |client,server,data|
                    @proxy.reset! if data.include?(string)
                  end
                end
              end

              if @close_server
                @close_server.each do |string|
                  @proxy.on_server_data do |client,server,data|
                    @proxy.close! if data.include?(string)
                  end
                end
              end

              if @ignore_server
                @ignore_server.each do |string|
                  @proxy.on_server_data do |client,server,data|
                    @proxy.ignore! if data.include?(string)
                  end
                end
              end

              if @rewrite_server
                @rewrite_server.each do |string,replace|
                  @proxy.on_server_data do |client,server,data|
                    data.gsub!(string,replace)
                  end
                end
              end

              if @reset
                @reset.each do |string|
                  @proxy.on_data do |client,server,data|
                    @proxy.reset! if data.include?(string)
                  end
                end
              end

              if @close
                @close.each do |string|
                  @proxy.on_data do |client,server,data|
                    @proxy.close! if data.include?(string)
                  end
                end
              end

              if @ignore
                @ignore.each do |string|
                  @proxy.on_data do |client,server,data|
                    @proxy.ignore! if data.include?(string)
                  end
                end
              end

              if @rewrite
                @rewrite.each do |string,replace|
                  @proxy.on_data do |client,server,data|
                    data.gsub!(string,replace)
                  end
                end
              end

              @proxy.on_client_data do |client,server,data|
                print_outgoing client
                print_data data
              end

              @proxy.on_server_data do |client,server,data|
                print_incoming client
                print_data data
              end

              @proxy.start
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
              end
            end

            def print_incoming(client,type=nil)
              print_info "#{address(client)} <- #{@proxy} #{type}"
            end

            def print_outgoing(client,type=nil)
              print_info "#{address(client)} -> #{@proxy} #{type}"
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

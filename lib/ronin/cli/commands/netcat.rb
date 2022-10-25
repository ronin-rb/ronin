#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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
# along with Ronin.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/cli/command'
require 'ronin/core/cli/logging'
require 'ronin/support/network/ssl'

require 'command_kit/options/verbose'

module Ronin
  class CLI
    module Commands
      #
      # A `netcat` clone written in Ruby using the [async-io] gem.
      #
      # [async-io]: https://github.com/socketry/async-io#readme
      #
      # ## Usage
      #
      #     [options] [--tcp | --udp | --ssl | --tls] {HOST PORT | -l [HOST] PORT | --unix PATH}
      #
      # ## Options
      #
      #     -v, --verbose                    Enables verbose output
      #         --tcp                        Uses the TCP protocol
      #         --udp                        Uses the UDP protocol
      #     -U, --unix PATH                  Uses the UNIX socket protocol
      #     -l, --listen                     Listens for incoming connections
      #     -s, --source HOST                Source address to bind to
      #     -p, --source-port PORT           Source port to bind to
      #     -b, --buffer-size INT            Buffer size to use (Default: 4096)
      #     -x, --hexdump                    Hexdumps each message that is received
      #         --ssl                        Enables SSL mode
      #         --tls                        Enables TLS mode
      #         --ssl-version 1|1.1|1.2      Specifies the required SSL version
      #         --ssl-cert FILE              Specifies the SSL certificate file
      #         --ssl-key FILE               Specifies the SSL key file
      #         --ssl-verify none|peer|fail_if_no_peer_cert|client_once|true|false
      #                                      SSL verification mode
      #         --ssl-ca-bundle PATH         Path to the file or directory of CA certificates
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [HOST]                           The host to connect to or listen on
      #     [POST]                           The port to connect to
      #
      class Netcat < Command

        include Core::CLI::Logging
        include CommandKit::Options::Verbose

        usage '[options] [--tcp | --udp | --ssl | --tls] {HOST PORT | -l [HOST] PORT | --unix PATH}'

        option :tcp, desc: 'Uses the TCP protocol' do
          @protocol = :tcp
        end

        option :udp, desc: 'Uses the UDP protocol' do
          @protocol = :udp
        end

        option :unix, short: '-U',
                      value: {
                        type:  String,
                        usage: 'PATH'
                      },
                      desc: 'Uses the UNIX socket protocol' do
                        @protocol = :unix
                      end

        option :listen, short: '-l',
                        desc: 'Listens for incoming connections' do
                          @mode = :listen
                        end

        option :source, short: '-s',
                        value: {
                          type: String,
                          usage: 'HOST'
                        },
                        desc: 'Source address to bind to'

        option :source_port, short: '-p',
                             value: {
                               type: Integer,
                               usage: 'PORT'
                             },
                             desc: 'Source port to bind to'

        option :buffer_size, short: '-b',
                             value: {
                               type: Integer,
                               default: 4096
                             },
                             desc: 'Buffer size to use'

        option :hexdump, short: '-x',
                         desc: 'Hexdumps each message that is received'

        option :ssl, desc: 'Enables SSL mode'

        option :tls, desc: 'Enables TLS mode' do
          options[:ssl_version] = 1.2
        end

        option :ssl_version, value: {
                               type: Support::Network::SSL::VERSIONS.keys
                             },
                             desc: 'Specifies the required SSL version'

        option :ssl_cert, value: {
                            type: String,
                            usage: 'FILE'
                          },
                          desc: 'Specifies the SSL certificate file'

        option :ssl_key, value: {
                           type: String,
                           usage: 'FILE',
                         },
                         desc: 'Specifies the SSL key file'

        option :ssl_verify, value: {
                              type: Support::Network::SSL::VERIFY.keys
                            },
                            desc: 'SSL verification mode'

        option :ssl_ca_bundle, value: {
                                 type: String,
                                 usage: 'PATH'
                               },
                               desc: 'Path to the file or directory of CA certificates'

        argument :host, required: false,
                        desc: 'The host to connect to or listen on'

        argument :post, required: false,
                        desc: 'The port to connect to'

        man_page 'ronin-netcat.1'

        # The protocol to use.
        #
        # @return [:tcp, :udp, :unix]
        attr_reader :protocol

        # Whether to connect or listen for connections.
        #
        # @return [:connect, :listen]
        attr_reader :mode

        #
        # Initializes the command.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        def initialize(**kwargs)
          super(**kwargs)

          @protocol = :tcp
          @mode     = :connect
        end

        #
        # Runs the `ronin netcat` command.
        #
        # @param [Array<String>] args
        #   Additional command-line arguments.
        #
        def run(*args)
          if options[:hexdump]
            require 'hexdump'
            @hexdump = Hexdump::Hexdump.new
          end

          case @mode
          when :connect
            @host, @port = *args

            unless @host
              print_error "host argument required"
              exit(-1)
            end

            unless @port
              print_error "port argument required"
              exit(-1)
            end

            if options[:verbose]
              if @protocol == :unix
                log_info "Connecting to #{options[:unix]} ..."
              else
                log_info "Connecting to #{@host}:#{@port} ..."
              end
            end

            load_async
            client_loop
          when :listen
            case args.length
            when 0
              @port = options.fetch(:port,0)
              @host = nil
            when 1
              @port = args[0].to_i
              @host = nil
            when 2
              @host = args[0]
              @port = args[1].to_i
            end

            if options[:verbose]
              if @protocol == :unix
                log_info "Listening on #{options[:unix]} ..."
              else
                if @host
                  log_info "Listening #{@host}:#{@port} ..."
                else
                  log_info "Listening port #{@port} ..."
                end
              end
            end

            load_async
            server_loop
          end
        end

        #
        # Loads the async-io library.
        #
        def load_async
          require 'async/notification'
          require 'async/io'
          require 'async/io/stream'
        end

        #
        # Creates an SSL context.
        #
        # @return [Ronin::Support::Network::SSL]
        #
        def ssl_context
          Support::Network::SSL.context(
            version:   options[:ssl_version],
            verify:    options[:ssl_verify],
            key_file:  options[:ssl_key],
            cert_file: options[:ssl_cert],
            ca_bundle: options[:ssl_ca_bundle]
          )
        end

        #
        # Creates the async endpoint object.
        #
        # @return [Async::IO::Endpoint]
        #
        def async_endpoint
          case @protocol
          when :tcp  then Async::IO::Endpoint.tcp(@host,@port)
          when :udp  then Async::IO::Endpoint.udp(@host,@port)
          when :unix then Async::IO::Endpoint.unix(options[:unix])
          when :ssl
            Async::IO::Endpoint.ssl(@host,@port, hostname:    @host,
                                                 ssl_context: ssl_context)
          end
        end

        #
        # Creates the async stdin stream.
        #
        # @return [Async::IO::Stream]
        #
        def async_stdin
          Async::IO::Stream.new(Async::IO::Generic.new(self.stdin))
        end

        #
        # The client event loop.
        #
        def client_loop
          endpoint = async_endpoint
          stdin = async_stdin
          finished = Async::Notification.new

          buffer_size = options[:buffer_size]

          Async do |task|
            socket = begin
                       endpoint.connect
                     rescue => error
                       print_error(error.message)
                       exit(1)
                     end

            stream = Async::IO::Stream.new(socket)

            begin
              client = task.async do
                begin
                  while (data = stream.read_partial(buffer_size))
                    print_data(data)
                  end
                rescue EOFError
                ensure
                  finished.signal
                end
              end

              user = task.async do
                begin
                  while (data = stdin.read_partial(buffer_size))
                    socket.write(data)
                  end
                rescue EOFError
                ensure
                  finished.signal
                end
              end

              finished.wait
            ensure
              client.stop
              user.stop
              socket.close
            end
          end
        end

        #
        # The server event loop.
        #
        def server_loop
          endpoint = async_endpoint
          stdin = async_stdin
          finished = Async::Notification.new

          buffer_size = options[:buffer_size]
          clients = []

          Async do |task|
            endpoint.accept do |socket|
              if options[:verbose]
                log_info "Client #{socket} connected"
              end

              clients << socket
              stream = Async::IO::Stream.new(socket)

              begin
                while (data = stream.read_partial(buffer_size))
                  print_data(data)
                end
              rescue EOFError
              end

              clients.delete(socket)

              if options[:verbose]
                log_warn "Client #{socket} disconnected"
              end
            end

            task.async do
              begin
                while (data = stdin.read_partial(buffer_size))
                  clients.each { |client| client.write(data) }
                end
              rescue EOFError
              ensure
                finished.signal
              end
            end

            finished.wait
          rescue => error
            print_error(error.message)
            exit(1)
          ensure
            clients.each(&:close)
          end
        end

        #
        # Prints or hexdumps data to stdout.
        #
        # @param [String] data
        #   The data to print or hexdump.
        #
        def print_data(data)
          if @hexdump
            @hexdump.hexdump(data)
          else
            print(data)
          end
        end

      end
    end
  end
end

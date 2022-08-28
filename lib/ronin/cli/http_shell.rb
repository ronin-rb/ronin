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

require 'ronin/core/cli/command_shell'
require 'ronin/cli/printing/http'

require 'ronin/support/network/http'

module Ronin
  class CLI
    class HTTPShell < Core::CLI::CommandShell

      include Printing::HTTP

      # The base URI.
      #
      # @return [URI::HTTP]
      attr_reader :base_url

      # The HTTP session.
      #
      # @return [Ronin::Support::Network::HTTP]
      attr_reader :http

      #
      # Initializes the HTTP Shell.
      #
      # @param [URI::HTTP, String] base_url
      #   The base URL to connect to.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional arguments for `Ronin::Support::Network::HTTP#connect_uri`.
      #
      def initialize(base_url, **kwargs)
        @base_url = URI(base_url)
        @http     = Support::Network::HTTP.connect_uri(@base_url,**kwargs)

        super()
      end

      # The shell prompt name.
      #
      # @return [String]
      #   Returns the {#base_url} as a String.
      #
      def shell_name
        "#{@base_url}"
      end

      command :get, usage:   'PATH[?QUERY] [BODY]',
                    summary: 'Performs a GET request'

      #
      # The `get` shell command.
      #
      # @param [String] path
      #
      # @param [String, nil] body
      #
      def get(path,body=nil)
        request(:get,path, body: body)
      end

      command :head, usage:   'PATH[?QUERY]',
                     summary: 'Performs a HEAD request'

      #
      # The `head` shell command.
      #
      # @param [String] path
      #
      def head(path)
        request(:head,path)
      end

      command :patch, usage:   'PATH[?QUERY] [BODY]',
                      summary: 'Performs a PATCH request'

      #
      # The `patch` shell command.
      #
      # @param [String] path
      #
      # @param [String] body
      #
      def patch(path,body=nil)
        request(:patch,path, body: body)
      end

      command :post, usage:   'PATH[?QUERY] [BODY]',
                     summary: 'Performs a POST request'

      #
      # The `post` shell command.
      #
      # @param [String] path
      #
      # @param [String, nil] body
      #
      def post(path,body)
        request(:post,path, body: body)
      end

      command :put, usage:   'PATH [BODY]',
                    summary: 'Performs a PUT request'

      #
      # The `patch` shell command.
      #
      # @param [String] path
      #
      # @param [String, nil] body
      #
      def put(path,body=nil)
        request(:put,path, body: body)
      end

      command :copy, usage:   'PATH DEST',
                     summary: 'Performs a COPY request'

      #
      # The `copy` shell command.
      #
      # @param [String] path
      #
      # @param [String] dest
      #
      def copy(path,dest)
        request(:copy,path, destination: dest)
      end

      command :delete, usage:   'PATH[?QUERY]',
                       summary: 'Performs a DELETE request'

      #
      # The `delete` shell command.
      #
      # @param [String] path
      #  
      def delete(path)
        request(:delete,path)
      end

      command :lock, usage:   'PATH[?QUERY]',
                     summary: 'Performs a LOCK request'

      #
      # The `lock` shell command.
      #
      # @param [String] path
      #
      def lock(path)
        request(:lock,path)
      end

      command :options, usage:   'PATH[?QUERY]',
                        summary: 'Performs a OPTIONS request'

      #
      # The `options` shell command.
      #
      # @param [String] path
      #
      def options(path)
        request(:options,path)
      end

      command :mkcol, usage:   'PATH[?QUERY]',
                      summary: 'Performs a MKCOL request'

      #
      # The `mkcol` shell command.
      #
      # @param [String] path
      #
      def mkcol(path)
        request(:mkcol,path)
      end

      command :move, usage:   'PATH[?QUERY] DEST',
                     summary: 'Performs a MOVE request'

      #
      # The `move` shell command.
      #
      # @param [String] path
      #
      # @param [String] dest
      #
      def move(path,dest)
        request(:move,path, destination: dest)
      end

      command :propfind, usage:   'PATH[?QUERY]',
                         summary: 'Performs a PROPFIND request'

      #
      # The `propfind` shell command.
      #
      # @param [String] path
      #
      def propfind(path)
        request(:propfind,path)
      end

      command :proppatch, usage:   'PATH[?QUERY]',
                          summary: 'Performs a PROPPATCH request'
      #
      # The `proppatch` shell command.
      #
      # @param [String] path
      #
      def proppatch(path)
        request(:proppatch,path)
      end

      command :trace, usage:   'PATH[?QUERY]',
                      summary: 'Performs a TRACE request'

      #
      # The `trace` shell command.
      #
      # @param [String] path
      #
      def trace(path)
        request(:trace,path)
      end

      command :unlock, usage:   'PATH[?QUERY]',
                       summary: 'Performs a UNLOCK request'

      #
      # The `unlock` shell command.
      #
      # @param [String] path
      #
      def unlock(path)
        request(:unlock,path)
      end

      command :cd, usage:   'PATH',
                   summary: 'Changes the base URL path'

      #
      # The `cd` shell command.
      #
      # @param [String] path
      #
      def cd(path)
        @base_url.path = join(path)
      end

      command :headers, usage:   '[{set | unset} NAME [VALUE]]',
                        summary: 'Manages the request headers'

      #
      # The `set_header` shell command.
      #
      # @param [String, nil] subcommand
      #   The optional sub-command (ex: `"set"` or `"unset"`).
      #
      # @param [String, nil] name
      #   The optional header name to set/unset.
      #
      # @param [String, nil] value
      #   The optional value of the header to set.
      #
      def headers(subcommand=nil,name=nil,value=nil)
        case subcommand
        when 'set'
          if (name && value)
            @http.headers[name] = value
          else
            puts "headers: must specify both NAME and VALUE arguments"
          end
        when 'unset'
          if name
            @http.headers.delete(name)
          else
            puts "headers: must specify NAME argument"
          end
        when nil
          unless @http.headers.empty?
            @http.headers.each do |name,value|
              puts "#{colors.bold(name)}: #{value}"
            end
          else
            puts "No request headers set"
          end
        else
          puts "headers: unknown sub-command: #{subcommand.inspect}"
        end
      end

      #
      # Joins the given path with the {#base_url}.
      #
      # @param [String] path
      #   The path to join.
      #
      # @return [String]
      #   The resulting joined path.
      #
      def join(path)
        if path.start_with?('/')
          path
        else
          File.expand_path(File.join(@base_url.path,path))
        end
      end

      #
      # Sends an HTTP request.
      #
      # @param [Symbol] method
      #   The HTTP request mehtod name.
      #
      # @param [String] path
      #   The path for the request.
      #
      # @param [Hash{Symbol => Object}] kwargs
      #   Additional keyword arguments for
      #   `Ronin::Support::Network::HTTP#request`.
      #
      def request(method,path,**kwargs)
        path = join(path)

        @http.request(method,path) do |response|
          print_response(response)
        end
      end

      #
      # Prints an HTTP response.
      #
      # @param [Net::HTTPResponse] response
      #   The HTTP response object.
      #
      # @see HTTPMethods#print_response
      #
      def print_response(response)
        super(response, show_headers: true)
      end

    end
  end
end

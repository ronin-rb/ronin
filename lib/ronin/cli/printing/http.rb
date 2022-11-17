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

require 'ronin/cli/printing/syntax_highlighting'

module Ronin
  class CLI
    module Printing
      #
      # Common methods for {Commands::Http} and {HTTPShell}.
      #
      module HTTP
        include SyntaxHighlighting

        #
        # Ensures that a final new-line is printed after the given text.
        #
        # @param [String] text
        #   The previous text that was printed.
        #
        def print_last_newline(text)
          if (stdout.tty? && text && !text.end_with?("\n"))
            puts
          end
        end

        #
        # Prints a plain unhighlighted response body.
        #
        # @param [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        def print_plain_body(response)
          last_chunk = nil

          response.read_body do |chunk|
            print chunk

            last_chunk = chunk
          end

          print_last_newline(last_chunk)
        end

        #
        # Returns the syntax lexer for the given `Content-Type` header.
        #
        # @param [String] content_type
        #   The HTTP `Content-Type` header value.
        #
        # @return [Rouge::Lexers::HTML,
        #          Rouge::Lexers::XML,
        #          Rouge::Lexers::JavaScript,
        #          Rouge::Lexers::JSON,
        #          Rouge::Lexers::PlainText]
        #   The specific syntax lexer or `nil` if the `Content-Type` was not
        #   recognized.
        #
        def syntax_lexer_for_content_type(content_type)
          syntax_lexer_for(mimetype: content_type.sub(/;.*$/,''))
        end

        #
        # Prints a syntax highlgihted response body.
        #
        # @param [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        def print_highlighted_body(response)
          content_type = response['Content-Type']
          is_utf8      = content_type && content_type.include?('charset=utf-8')

          lexer      = syntax_lexer_for_content_type(content_type)
          last_chunk = nil

          response.read_body do |chunk|
            chunk.force_encoding(Encoding::UTF_8) if is_utf8

            print @syntax_formatter.format(lexer.lex(chunk))

            last_chunk = chunk
          end

          print_last_newline(last_chunk)
        end

        #
        # Prints the response body.
        #
        # @param [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        def print_body(response)
          if ansi?
            print_highlighted_body(response)
          else
            print_plain_body(response)
          end
        end

        #
        # Prints the respnse headers.
        #
        # @param [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        def print_headers(response)
          color = if    response.code < '300' then colors.green
                  elsif response.code < '400' then colors.yellow
                  else                             colors.red
                  end

          puts "#{colors.bold}#{color}HTTP/#{response.http_version} #{response.code}#{colors.reset}"

          response.each_capitalized do |name,value|
            puts "#{color}#{colors.bold(name)}: #{value}#{colors.reset}"
          end

          puts
        end

        #
        # Prints the response.
        #
        # @param [Net::HTTPResponse] response
        #   The HTTP response object.
        #
        # @param [Boolean] show_headers
        #   Controls whether the response headers are printed.
        #
        def print_response(response, show_headers: nil)
          print_headers(response) if show_headers
          print_body(response)
        end
      end
    end
  end
end

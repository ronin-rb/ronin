# frozen_string_literal: true
#
# Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/cli/file_processor_command'
require 'ronin/cli/printing/syntax_highlighting'

require 'command_kit/pager'

module Ronin
  class CLI
    module Commands
      #
      # Syntax highlights a file(s).
      #
      # ## Usage
      #
      #     ronin highlight [options] [FILES ...]
      #
      # ## Options
      #
      #     -s, --syntax                     Specifies the syntax to highlight
      #     -L, --less                       Display the output in a pager
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [FILE ...]                       Option file(s) to process
      #
      class Highlight < FileProcessorCommand

        include Printing::SyntaxHighlighting
        include CommandKit::Pager

        usage '[options] [FILE ...]'

        option :syntax, short: '-s',
                        desc:  'Specifies the syntax to highlight' do |syntax|
                          unless (lexer = syntax_lexer(options[:syntax]))
                            raise(OptionParser::InvalidArgument,"unknown syntax: #{options[:syntax]}")
                          end

                          @syntax_lexer = lexer.new
                        end

        option :less, short: '-L',
                      desc:  'Display the output in a pager'

        description 'Syntax highlights file(s).'

        man_page 'ronin-highlight.1'

        #
        # Indicates that ANSI mode is always enabled.
        #
        # @return [true]
        #
        def ansi?
          true
        end

        #
        # Syntax highlights a file.
        #
        # @param [String] file
        #
        def process_file(file)
          @syntax_lexer ||= syntax_lexer_for(filename: file)

          super(file)
        end

        #
        # Syntax highlights an input strema.
        #
        # @param [File, IO] input
        #   The input file or `stdin`.
        #
        def process_input(input)
          if options[:less]
            pager do |less|
              syntax_highlight(input, output: less)
            end
          else
            syntax_highlight(input)
          end
        end

        #
        # Syntax highlights the input stream and prints to the output stream.
        #
        # @param [File, IO] input
        #   The input file or `stdin`.
        #
        # @param [IO] output
        #   The `less` output stream or `stdout`.
        #
        def syntax_highlight(input, output: stdout)
          input.each_line do |line|
            output.print(@syntax_formatter.format(@syntax_lexer.lex(line)))
          end
        end

      end
    end
  end
end

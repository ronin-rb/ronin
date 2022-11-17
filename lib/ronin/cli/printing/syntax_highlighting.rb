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

require 'command_kit/colors'
require 'rouge'

module Ronin
  class CLI
    module Printing
      module SyntaxHighlighting
        include CommandKit::Colors

        #
        # Initializes the syntax highlighter.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments.
        #
        def initialize(**kwargs)
          super(**kwargs)

          if ansi?
            @syntax_formatter = syntax_formatter
          end
        end

        #
        # Loads the syntax lexer for the filename, mimetype, or source code.
        #
        # @param [String] filename
        #   The filename to infer the syntax from.
        #
        # @param [String] mimetype
        #   The MIME-type to infer the syntax from.
        #
        # @param [String] source
        #   The source code to infer the syntax from.
        #
        # @return [Rouge::Lexer]
        #
        def syntax_lexer_for(filename: nil, mimetype: nil, source: nil)
          Rouge::Lexer.guess(
            filename: filename,
            mimetype: mimetype,
            source:   source
          )
        end

        #
        # Looks up the syntax lexer class.
        #
        # @param [String] name
        #   The syntax name.
        #
        # @return [Class<Rouge::Lexer>, nil]
        #
        def syntax_lexer(name)
          Rouge::Lexer.find(name)
        end

        #
        # The syntax highlighter theme.
        #
        # @return [Rouge::Theme]
        #
        def syntax_theme
          Rouge::Themes::Molokai.new
        end

        #
        # The syntax formatter.
        #
        # @return [Rouge::Formatters::Terminal256]
        #
        def syntax_formatter
          Rouge::Formatters::Terminal256.new(syntax_theme)
        end
      end
    end
  end
end

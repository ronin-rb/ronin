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
  module Shell

    # Default shell prompt
    DEFAULT_PROMPT = '>'

    #
    # Creates and starts a new Shell object with the specified _options_.
    # If a _block_ is given, it will be passed every command.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :name ('')
    #   The shell-name to use before the prompt.
    #
    # @option options [String] :prompt (DEFAULT_PROMPT)
    #   The prompt to use for the shell.
    #
    # @yield [shell, line]
    #   The block that will be passed every command entered.
    #
    # @yieldparam [Shell] shell
    #   The shell to use for output.
    #
    # @yieldparam [String] line
    #   The command entered into the shell.
    #
    # @return [nil]
    #
    # @example
    #   Shell.start(:prompt => '$') { |shell,line| system(line) }
    #
    def Shell.start(options={},&block)
      name = (options[:name] || '')
      prompt = (options[:prompt] || DEFAULT_PROMPT)

      history_rollback = 0

      loop do
        line = Readline.readline("#{name}#{prompt} ")

        if line =~ /^\s*exit\s*$/
          break
        else
          Readline::HISTORY << line
          history_rollback += 1

          begin
            block.call(self,line)
          rescue => e
            puts "#{e.class.name}: #{e.message}"
          end
        end
      end

      history_rollback.times { Readline::HISTORY.pop }
      return nil
    end

    #
    # Print a character to the shell.
    #
    # @param [String] char
    #   The character to print.
    #
    def Shell.putc(char)
      STDOUT.putc(char)
    end

    #
    # Print a String to the shell.
    #
    # @param [String] string
    #   The String to print.
    #
    def Shell.print(string)
      STDOUT.print(string)
    end

    #
    # Print a String and a new-line character to the shell.
    #
    # @param [String] string
    #   The String to print.
    #
    def Shell.puts(string)
      STDOUT.puts(string)
    end

    #
    # Render the format-string and print the result to the shell.
    #
    # @param [String] string
    #   The format-string to render.
    #
    # @param [Array] objects
    #   Additional objects to use in the format-string.
    #
    def Shell.printf(string,*objects)
      STDOUT.printf(string,*objects)
    end

  end
end

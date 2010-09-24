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

require 'ronin/ui/output/helpers'

module Ronin
  module UI
    module Shell

      extend Output::Helpers

      # Default shell prompt
      DEFAULT_PROMPT = '>'

      #
      # Creates a new Shell object and starts it.
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

          if line =~ /^\s*(exit|quit)\s*$/
            break
          else
            Readline::HISTORY << line
            history_rollback += 1

            begin
              yield self, line
            rescue => e
              puts "#{e.class.name}: #{e.message}"
            end
          end
        end

        history_rollback.times { Readline::HISTORY.pop }
        return nil
      end

    end
  end
end

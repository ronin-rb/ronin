#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module Ronin
  module UI
    module Console
      #
      # Allows for executing shell commands as well as Ruby code.
      #
      # @since 1.2.0
      #
      module Shell
        # Names and statuses of executables.
        EXECUTABLES = Hash.new do |hash,key|
          hash[key] = Env.paths.any? do |dir|
            path = dir.join(key)

            (path.file? && path.executable?)
          end
        end

        # Blacklist of known commands that conflict with Ruby keywords.
        BLACKLIST = Set[
          '[', 'ap', 'begin', 'case', 'class', 'def', 'fail', 'false',
          'for', 'if', 'lambda', 'load', 'loop', 'module', 'p', 'pp',
          'print', 'proc', 'puts', 'raise', 'require', 'true', 'undef',
          'unless', 'until', 'warn', 'while'
        ]

        #
        # Dynamically execute shell commands, instead of Ruby.
        #
        # @param [String] input
        #   The input from the console.
        #
        # @api private
        #
        def loop_eval(input)
          if input[0,1] == '!'
            command = input[1..-1]
            name = command.split(' ',2).first

            if executable?(name)
              return system(command)
            end
          end

          super(input)
        end

        protected

        #
        # Determines if an executable exists on the system.
        #
        # @param [String] name
        #   The program name or path.
        #
        # @return [Boolean]
        #   Specifies whether the executable exists.
        #
        # @api private
        #
        def executable?(name)
          !BLACKLIST.include?(name) && (
            (File.file?(name) && File.executable?(name)) ||
            EXECUTABLES[name]
          )
        end
      end
    end
  end
end

Ripl::Shell.send :include, Ronin::UI::Console::Shell

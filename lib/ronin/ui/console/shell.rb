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

require 'env'

module Ronin
  module UI
    module Console
      #
      # Allows for executing shell commands as well as Ruby code.
      #
      # @since 1.2.0
      #
      module Shell
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

            if program?(name)
              return system(command)
            end
          end

          super(input)
        end

        protected

        #
        # Determines if a program exists.
        #
        # @param [String] name
        #   The name of the program to search for.
        #
        # @return [Boolean]
        #   Specifies whether the program exists.
        #
        def program?(name)
          executable = lambda { |path|
            (File.file?(path) && File.executable?(path))
          }

          executable[name] || Env.paths.any? { |dir|
            executable[dir.join(name)]
          }
        end
      end
    end
  end
end

Ripl::Shell.send :include, Ronin::UI::Console::Shell

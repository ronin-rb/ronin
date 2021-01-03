#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin.
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

require 'shellwords'
require 'tempfile'

module Ronin
  module UI
    module Console
      #
      # Allows for calling {Console} commands via the `.` prefix.
      #
      # ## Commands
      #
      # * {edit .edit}
      #
      # @since 1.2.0
      #
      # @api private
      #
      module Commands
        # Regexp to recognize `.commands`.
        PATTERN = /^\.[a-z][a-z0-9_]*/

        #
        # Check for the `.` prefix, and attempt to call the Console command.
        #
        # @param [String] input
        #   The input from the console.
        #
        def loop_eval(input)
          if (@buffer.nil? && input =~ PATTERN)
            command = input[1..-1]
            name, arguments = Shellwords.shellsplit(command)

            if Commands.singleton_class.method_defined?(name)
              arguments ||= []

              return Commands.send(name,*arguments)
            end
          end

          super(input)
        end

        #
        # Edits a path and re-loads the code.
        #
        # @param [String] path 
        #   The path of the file to re-load.
        #
        # @return [Boolean]
        #   Specifies whether the code was successfully re-loaded.
        #
        def self.edit(path=nil)
          if ENV['EDITOR']
            path ||= Tempfile.new(['ronin-console', '.rb']).path

            system(ENV['EDITOR'],path) && load(path)
          else
            print_error "Please set the EDITOR env variable"
            return false
          end
        end
      end
    end
  end
end

Ripl::Shell.send :include, Ronin::UI::Console::Commands

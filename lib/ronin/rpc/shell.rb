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

require 'ronin/rpc/service'
require 'ronin/ui/shell'

module Ronin
  module RPC
    class Shell < Service

      #
      # Executes the specified _program_ with the given _arguments_. The
      # output of the program will be returned as a String.
      #
      def exec(program,*arguments)
        call(:exec,program,*arguments)
      end

      #
      # Executes the specified _program_ with the given _arguments_ and
      # prints the output of the program.
      #
      def system(program,*arguments)
        print(exec(program,*arguments))
      end

      #
      # Starts a Shell that allows a user to execute commands and observe
      # their output.
      #
      def interact
        UI::Shell.start(:prompt => '$') { |shell,line| system(line) }
      end

      protected

      #
      # Relays missing methods to exec.
      #
      def method_missing(sym,*args)
        exec(sym,*args)
      end

    end
  end
end

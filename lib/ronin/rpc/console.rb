#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

require 'ronin/rpc/service'
require 'ronin/rpc/interactive_console'

module Ronin
  module RPC
    class Console < Service

      #
      # Invoke the the specified _method_ with the given _arguments_.
      # Returns the result of the method call.
      #
      def invoke(method,*arguments)
        call(:invoke,method,arguments)
      end

      #
      # Evaluates the specified _string_ of code. Returns the result of the
      # evaluated code.
      #
      def eval(string)
        invoke(:eval,string)
      end

      #
      # If _expression_ is given it will be evaluated and it's return value
      # will be returned as a natively formatted String. If _expression_ is
      # not given, the Object inspect method will be called.
      #
      def inspect(expression=nil)
        if string
          return call(:inspect,expression)
        else
          return super
        end
      end

      #
      # Starts an InteractiveConsole that allows a user to evaluate code
      # and inspect the return-value.
      #
      def interact
        InteractiveConsole.start(self)
      end

      protected

      #
      # Relays missing methods to invoke.
      #
      def method_missing(sym,*args)
        invoke(sym,*args)
      end

    end
  end
end

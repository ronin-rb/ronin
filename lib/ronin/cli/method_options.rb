#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'command_kit/options'

module Ronin
  class CLI
    #
    # Allows adding options which call methods on a given object.
    #
    module MethodOptions

      include CommandKit::Options

      # The method calls to apply to an object.
      #
      # @return [Array<Symbol, (Symbol, Array)>]
      attr_reader :method_calls

      #
      # Initializes {#method_calls}.
      #
      def initialize(**kwargs)
        super(**kwargs)

        @method_calls = []
      end

      #
      # Applies the method options to the given object.
      #
      # @param [Object] object
      #   The object to call the method options on.
      #
      # @return [Object]
      #   The final object.
      #
      def apply_method_options(object)
        @method_calls.each do |method,arguments,kwargs={}|
          unless object.respond_to?(method)
            print_error "cannot call method #{method} on a #{object.class} object: #{object.inspect}"
            exit(-1)
          end

          object = object.public_send(method,*arguments,**kwargs)
        end

        return object
      end

    end
  end
end

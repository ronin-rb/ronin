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

module Ronin
  class CLI
    #
    # Allows adding options which call methods on a given object.
    #
    module MethodOptions

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
      # @raise [ArgumentError]
      #   One of the method calls in {#method_calls} attempted to call a
      #   private/protected or global method on the object.
      #
      def apply_method_options(object)
        common_object_methods = Object.public_instance_methods

        @method_calls.each do |method,arguments,kwargs={}|
          allowed_methods = object.public_methods - common_object_methods

          unless allowed_methods.include?(method)
            raise(ArgumentError,"cannot call method Object##{method} on object #{object.inspect}")
          end

          object = object.public_send(method,*arguments,**kwargs)
        end

        return object
      end

    end
  end
end

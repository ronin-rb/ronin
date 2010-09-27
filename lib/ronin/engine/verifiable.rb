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

require 'ronin/engine/exceptions/verification_failed'

module Ronin
  module Engine
    module Verifiable
      def self.included(base)
        base.send :extend, ClassMethods
      end

      #
      # Initializes the verifiable engine.
      #
      # @param [Hash] attributes
      #   Additional attributes for the engine.
      #
      # @since 0.4.0
      #
      def initialize(attributes={})
        super(attributes)

        @verify_blocks = []
      end

      #
      # Verifies that the engine is properly configured.
      #
      # @return [true]
      #   The exploit is built and ready for deployment.
      #
      # @see verify
      #
      # @since 0.4.0
      #
      def verify!
        print_info "Verifying #{engine_name} ..."

        @verify_blocks.each { |block| block.call() }

        print_info "#{engine_name} verified!"
        return true
      end

      protected

      #
      # Flunks the verification.
      #
      # @param [String] message
      #   The message on why the verification failed.
      #
      # @raise [VerificationFailed]
      #   The verification failure message.
      #
      # @since 0.4.0
      #
      def flunk(message)
        raise(VerificationFailed,message,caller)
      end

      #
      # Registers a given block to be called when the engine is verified.
      #
      # @yield []
      #   The given block will be called when the engine is being verified.
      #
      # @return [Engine]
      #   The engine.
      #
      # @since 0.4.0
      #
      def verify(&block)
        @verify_blocks << block
        return self
      end

      #
      # Verifies an expression is true.
      #
      # @param [String] message
      #   The failure message if the expression was not true.
      #
      # @yield []
      #   The given block will contain the expression to evaluate.
      #
      # @return [true]
      #   The expression was true.
      #
      # @raise [VerificationFailed]
      #   The expression was not true.
      #
      # @since 0.4.0
      #
      def verify?(message,&block)
        verify { flunk(message) unless block.call() }
      end

      #
      # Verifies a method has the expected value.
      #
      # @param [Symbol] name
      #   The method to call.
      #
      # @param [Object] expected_value
      #   The expected value.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method returned the expected value.
      #
      # @raise [VerificationFailed]
      #   The method did not return the expected value.
      #
      # @since 0.4.0
      #
      def verify_equal(name,expected_value,message=nil)
        name = name.to_sym

        verify do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) must equal #{expected_value.inspect}"

          flunk(message) unless actual_value == expected_value
        end
      end

      #
      # Verifies a method does not have the unexpected value.
      #
      # @param [Symbol] name
      #   The method to call.
      #
      # @param [Object] unexpected_value
      #   The unexpected value.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method did not return the unexpected value.
      #
      # @raise [VerificationFailed]
      #   The method did return the unexpected value.
      #
      # @since 0.4.0
      #
      def verify_not_equal(name,unexpected_value,message=nil)
        name = name.to_sym

        verify do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) cannot equal #{unexpected_value.inspect}"

          flunk(message) unless actual_value != unexpected_value
        end
      end

      #
      # Verifies a method matches the pattern.
      #
      # @param [Symbol] name
      #   The method to call.
      #
      # @param [Regexp, String] pattern
      #   The pattern to match against.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method matched the pattern.
      #
      # @raise [VerificationFailed]
      #   The method did not match the pattern.
      #
      # @since 0.4.0
      #
      def verify_match(name,pattern,message=nil)
        name = name.to_sym

        verify do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) must match #{expected_value.inspect}"

          flunk(message) unless actual_value.match(expected_value)
        end
      end

      #
      # Verifies a method does not matches the pattern.
      #
      # @param [Symbol] name
      #   The method to call.
      #
      # @param [Regexp, String] pattern
      #   The pattern to match against.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method matched the pattern.
      #
      # @raise [VerificationFailed]
      #   The method did not match the pattern.
      #
      # @since 0.4.0
      #
      def verify_no_match(name,pattern,message=nil)
        name = name.to_sym

        verify do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) cannot match #{expected_value.inspect}"

          flunk(message) unless !actual_value.match(expected_value)
        end
      end

      #
      # Verify a method has a value in the expected values.
      #
      # @param [Symbol] name
      #   The method name.
      #
      # @param [Array<Object>]  expected_values
      #   The expected values.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method returned one of the expected values.
      #
      # @raise [VerificationFailed]
      #   The method did not return one of the expected values.
      #
      # @since 0.4.0
      #
      def verify_in(name,expected_values,message=nil)
        name = name.to_sym

        verify do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) must be one of #{expected_values.inspect}"

          flunk(message) unless expected_values.include?(actual_value)
        end
      end

      #
      # Verify a method does not have a value in the unexpected values.
      #
      # @param [Symbol] name
      #   The method name.
      #
      # @param [Array<Object>]  unexpected_values
      #   The unexpected values.
      #
      # @param [String] message
      #   Optional failure message.
      #
      # @return [true]
      #   The method did not return one of the unexpected values.
      #
      # @raise [VerificationFailed]
      #   The method did return one of the unexpected values.
      #
      # @since 0.4.0
      #
      def verify_not_in(name,unexpected_values,message=nil)
        name = name.to_sym

        verify do
          actual_value = self.send(name)
          message ||= "#{name} (#{actual_value.inspect}) cannot be one of #{unexpected_values.inspect}"

          flunk(message) unless !unexpected_values.include?(actual_value)
        end
      end
    end
  end
end

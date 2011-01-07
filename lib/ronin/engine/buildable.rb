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

require 'ronin/engine/exceptions/not_built'
require 'ronin/engine/verifiable'

module Ronin
  module Engine
    module Buildable
      include Verifiable

      #
      # Initializes the buildable engine.
      #
      # @param [Hash] attributes
      #   Additional attributes for the engine.
      #
      # @since 1.0.0
      #
      def initialize(attributes={})
        super(attributes)

        @build_blocks = []
        @built = false
      end

      #
      # Determines whether the engine has been built.
      #
      # @return [Boolean]
      #   Specifies whether the engine is built.
      #
      # @since 1.0.0
      #
      def built?
        @built == true
      end

      #
      # Builds the engine.
      #
      # @param [Hash] options
      #   Additional options to also use as parameters.
      #
      # @yield []
      #   The given block will be called after the engine has been built.
      #
      # @see #build
      #
      # @since 1.0.0
      #
      def build!(options={})
        self.params = options
        print_debug "#{engine_name} #{self} parameters: #{self.params.inspect}"

        print_info "Building #{engine_name} #{self} ..."

        @built = false
        @build_blocks.each { |block| block.call() }
        @built = true

        print_info "#{engine_name} #{self} built!"

        yield if block_given?
        return self
      end

      #
      # Verifies that the engine has been built and is properly configured.
      #
      # @return [true]
      #   The engine has been verified.
      #
      # @raise [NotBuilt]
      #   The engine has not been built, and cannot be verified.
      #
      # @see #verify
      #
      # @since 1.0.0
      #
      def verify!
        unless built?
          raise(NotBuilt,"cannot verify an unbuilt #{engine_name}")
        end

        super
      end

      protected

      #
      # Registers a given block to be called when the engine is built.
      #
      # @yield []
      #   The given block will be called when the engine is being built.
      #
      # @return [Engine]
      #   The engine.
      #
      # @since 1.0.0
      #
      def build(&block)
        @build_blocks << block
        return self
      end
    end
  end
end

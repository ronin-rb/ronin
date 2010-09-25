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
      # @since 0.4.0
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
      # @since 0.4.0
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
      # @since 0.4.0
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
      # @since 0.4.0
      #
      def verify!
        unless built?
          raise(NotBuilt,"cannot verify an unbuilt #{engine_name}",caller)
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
      # @since 0.4.0
      #
      def build(&block)
        @build_blocks << block
        return self
      end
    end
  end
end

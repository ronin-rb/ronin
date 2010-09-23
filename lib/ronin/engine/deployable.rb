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

require 'ronin/engine/exceptions/deploy_failed'
require 'ronin/engine/verifiable'

module Ronin
  module Engine
    module Deployable
      include Verifiable

      #
      # Initializes the deployable engine.
      #
      # @param [Hash] attributes
      #   Additional attributes for the engine.
      #
      # @since 0.4.0
      #
      def initialize(attributes={})
        super(attributes)

        @deploy_block = nil
        @deployed = false

        @cleanup_block = nil
        @cleaned = false
      end

      #
      # Determines whether the engine was deployed.
      #
      # @return [Boolean]
      #   Specifies whether the engine was previously deployed.
      #
      # @since 0.4.0
      #
      def deployed?
        @deployed == true
      end

      #
      # Verifies then deploys the exploit. If a payload has been set,
      # the payload will also be deployed.
      #
      # @yield []
      #   If a block is given, it will be passed the deployed engine.
      #
      # @return [Engine]
      #   The deployed engine.
      #
      # @see deploy
      #
      # @since 0.4.0
      #
      def deploy!
        verify!

        print_info "Deploying #{engine_type} #{self} ..."

        @deployed = false
        @deploy_block.call() if @deploy_block
        @deployed = true
        @cleaned = false

        print_info "#{engine_type} #{self} deployed!"

        yield if block_given?
        return self
      end

      #
      # Determines whether the engine was cleaned up.
      #
      # @return [Boolean]
      #   Specifies whether the engine has been cleaned up.
      #
      # @since 0.4.0
      #
      def cleaned?
        @cleaned == true
      end

      #
      # Cleans the built engine.
      #
      # @yield []
      #   If a block is given, it will be called before the engine is
      #   cleaned.
      #
      # @return [Engine]
      #   The cleaned engine.
      #
      # @see #cleanup
      #
      # @since 0.4.0
      #
      def cleanup!
        yield if block_given?

        print_info "Cleaning up #{engine_type} #{self} ..."

        @cleaned = false
        @cleanup_block.call() if @cleanup_block
        @cleaned = true
        @deployed = false

        print_info "#{engine_type} #{self} cleaned."
        return self
      end

      protected

      #
      # Indicates the deployment of the exploit has failed.
      #
      # @raise [DeployFailed]
      #   The deployment of the exploit failed.
      #
      # @since 0.4.0
      #
      def deploy_failed!(message)
        raise(DeployFailed,message,caller)
      end

      #
      # Registers a given block to be called when the engine is being
      # deployed.
      #
      # @yield []
      #   The given block will be called when the engine is being
      #   deployed.
      #
      # @return [Engine]
      #   The engine.
      #
      # @since 0.4.0
      #
      def deploy(&block)
        @deploy_block = block
        return self
      end

      #
      # Registers a given block to be called when the engine is being
      # cleaned up.
      #
      # @yield []
      #   The given block will be called when the engine is being
      #   cleaned up.
      #
      # @return [Engine]
      #   The engine.
      #
      # @since 0.4.0
      #
      def cleanup(&block)
        @cleanup_block = block
        return self
      end
    end
  end
end

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
      # @since 1.0.0
      #
      def initialize(attributes={})
        super(attributes)

        @deploy_blocks = []
        @deployed = false

        @evacuate_blocks = []
        @evacuated = false
      end

      #
      # Determines whether the engine was deployed.
      #
      # @return [Boolean]
      #   Specifies whether the engine was previously deployed.
      #
      # @since 1.0.0
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
      # @since 1.0.0
      #
      def deploy!
        verify!

        print_info "Deploying #{engine_name} #{self} ..."

        @deployed = false
        @deploy_blocks.each { |block| block.call() }
        @deployed = true
        @evacuated = false

        print_info "#{engine_name} #{self} deployed!"

        yield if block_given?
        return self
      end

      #
      # Determines whether the engine was evacuated.
      #
      # @return [Boolean]
      #   Specifies whether the engine has been evacuated.
      #
      # @since 1.0.0
      #
      def evacuated?
        @evacuated == true
      end

      #
      # Evacuates the deployed engine.
      #
      # @yield []
      #   If a block is given, it will be called before the engine is
      #   evacuated.
      #
      # @return [Engine]
      #   The evacuated engine.
      #
      # @see #evacuate
      #
      # @since 1.0.0
      #
      def evacuate!
        yield if block_given?

        print_info "Evauating #{engine_name} #{self} ..."

        @evacuated = false
        @evacuate_blocks.each { |block| block.call() }
        @evacuated = true
        @deployed = false

        print_info "#{engine_name} #{self} evacuated."
        return self
      end

      protected

      #
      # Indicates the deployment of the exploit has failed.
      #
      # @raise [DeployFailed]
      #   The deployment of the exploit failed.
      #
      # @since 1.0.0
      #
      def deploy_failed!(message)
        raise(DeployFailed,message)
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
      # @since 1.0.0
      #
      def deploy(&block)
        @deploy_blocks << block
        return self
      end

      #
      # Registers a given block to be called when the engine is being
      # evacuated.
      #
      # @yield []
      #   The given block will be called when the engine is being
      #   evacuated.
      #
      # @return [Engine]
      #   The engine.
      #
      # @since 1.0.0
      #
      def evacuate(&block)
        @evacuate_blocks.unshift(block)
        return self
      end
    end
  end
end

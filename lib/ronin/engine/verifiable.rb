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

module Ronin
  module Engine
    module Verifiable
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

        @verify_block.call() if @verify_block

        print_info "#{engine_name} verified!"
        return true
      end

      protected

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
        @verify_block = block
        return self
      end
    end
  end
end

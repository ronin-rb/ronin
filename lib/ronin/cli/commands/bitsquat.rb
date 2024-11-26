# frozen_string_literal: true
#
# Copyright (c) 2006-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative '../value_processor_command'

require 'ronin/support/binary/bit_flip/core_ext/string'
require 'ronin/support/text/patterns/network'
require 'ronin/support/network/host'

module Ronin
  class CLI
    module Commands
      #
      # Finds bit-flips of a domain.
      #
      # ## Usage
      #
      #     ronin bitsquat [options] [DOMAIN ...]
      #
      # ## Options
      #
      #     -f, --file FILE                  Optional file to read values from
      #         --has-addresses              Print bitsquat domains with addresses
      #         --registered                 Print bitsquat domains that are already registered
      #         --unregistered               Print bitsquat domains that can be registered
      #     -h, --help                       Print help information
      #
      # ## Arguments
      #
      #     [DOMAIN ...]                     The domain to bit-flip
      #
      class Bitsquat < ValueProcessorCommand

        usage '[options] [DOMAIN ...]'

        option :has_addresses, desc: 'Print bitsquat domains with addresses'

        option :registered, desc: 'Print bitsquat domains that are already registered'

        option :unregistered, desc: 'Print bitsquat domains that can be registered'

        argument :domain, required: false,
                          repeats:  true,
                          desc:     'The domain to bit-flip'

        description "Finds bit-flips of a domain"

        man_page 'ronin-bitsquat.1'

        # Regular expression for a valid host name.
        VALID_HOST_NAME = /\A#{Support::Text::Patterns::HOST_NAME}\z/

        #
        # Queries the bit-flips of a domain.
        #
        # @param [String] domain
        #   The string to bit-flip and query.
        #
        def process_value(domain)
          if options[:has_addresses]
            each_bit_squat(domain) do |host|
              puts host if host.has_addresses?
            end
          elsif options[:registered]
            each_bit_squat(domain) do |host|
              puts host if host.registered?
            end
          elsif options[:unregistered]
            each_bit_squat(domain) do |host|
              puts host if host.unregistered?
            end
          else
            each_bit_squat(domain) do |host|
              puts host
            end
          end
        end

        #
        # Enumerates over each bitsquat of the domain.
        #
        # @param [String] domain
        #   The domain to check for bitsquats.
        #
        # @yield [bitsquat_host]
        #   The given block will be passed each bitsquatted domain variant.
        #
        # @yieldparam [Ronin::Support::Network::Host] bitsquat_host
        #   A host object for the bitsquatted domain variant.
        #
        def each_bit_squat(domain)
          domain.each_bit_flip do |bit_flipped|
            bit_flipped.force_encoding(Encoding::UTF_8)

            if bit_flipped.valid_encoding? && bit_flipped =~ VALID_HOST_NAME
              yield Support::Network::Host.new(bit_flipped)
            end
          end
        end

      end
    end
  end
end

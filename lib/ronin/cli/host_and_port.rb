# frozen_string_literal: true
#
# Copyright (c) 2006-2026 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'addressable'

module Ronin
  class CLI
    #
    # Mixin which adds methods for parsing `host:port` pairs.
    #
    module HostAndPort
      #
      # Parses a `host:port` pair.
      #
      # @param [String] string
      #   The string containing the `host:port` pair.
      #
      # @return [(String, Integer)]
      #   The parsed host and port.
      #
      def host_and_port(string)
        host, port = string.split(':',2)

        return host, port.to_i
      end

      #
      # Parses the host and port from the given URL.
      #
      # @param [String] url
      #   The URL to parse.
      #
      # @return [(String, Integer)]
      #   The host and port components of the URL.
      #
      def host_and_port_from_url(url)
        uri = Addressable::URI.parse(url)

        return uri.normalized_host, uri.inferred_port
      end
    end
  end
end

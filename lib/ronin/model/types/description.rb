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

require 'dm-core'

module Ronin
  module Model
    module Types
      class Description < DataMapper::Type

        primitive DataMapper::Types::Text

        #
        # Typecasts the description.
        #
        # @param [Object] value
        #   The text of the description.
        #
        # @param [DataMapper::Property] property
        #   The description property.
        #
        # @return [String, nil]
        #   The typecasted description.
        #
        # @since 0.4.0
        #
        def self.typecast(value,property)
          case value
          when nil
            nil
          else
            sanitized_lines = []

            value.to_s.each_line do |line|
              sanitized_lines << line.strip
            end

            return sanitized_lines.join("\n").strip
          end
        end

      end
    end
  end
end

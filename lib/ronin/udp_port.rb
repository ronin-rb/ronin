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

require 'ronin/port'

module Ronin
  #
  # Represents a UDP {Port}.
  #
  class UDPPort < Port

    #
    # Creates a new {UDPPort} resource.
    #
    # @param [Hash] attributes
    #   The attribute names and values to initialize the udp port with.
    #
    def initialize(attributes={})
      super(attributes.merge(:protocol => 'udp'))
    end

  end
end

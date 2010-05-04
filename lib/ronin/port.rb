#
# Ronin - A Ruby platform for exploit development and security research.
#
# Copyright (c) 2009-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/open_port'
require 'ronin/model'

module Ronin
  class Port

    include Model

    # Primary key of the port
    property :id, Serial

    # The protocol of the port (tcp/udp)
    property :protocol, String, :set => ['tcp', 'udp'],
                                :required => true,
                                :unique_index => :protocol_port

    # The port number
    property :number, Integer, :required => true,
                               :unique_index => :protocol_port

    # The open ports
    has 1..n, :open_ports

    validates_is_unique :number, :scope => [:protocol]

    #
    # Converts the port to an integer.
    #
    # @return [Integer]
    #   The port number.
    #
    # @since 0.4.0
    #
    def to_i
      self.number.to_i
    end

    #
    # Converts the port to a string.
    #
    # @return [String]
    #   The port number and protocol.
    #
    # @since 0.4.0
    #
    def to_s
      "#{self.number}/#{self.protocol}"
    end

  end
end

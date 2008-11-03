#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#++
#

module Ronin
  class Encoder

    #
    # Creates a new Encoder object with the given _options_. If a _block_
    # is given, it will be passed the newly created Encoder object.
    #
    def initialize(options={},&block)
      block.call(self) if block
    end

    #
    # Encodes the specified _data_ with given _options_. If a _block_ is
    # given it will be passed the encoded data.
    #
    def self.encode(data,options={},&block)
      self.new(options).encode(data,&block)
    end

    #
    # The default encoding method which simply returns the specified _data_.
    # If a _block_ is given, it will be passed the specified _data_.
    #
    def encode(data,&block)
      block.call(data) if block
      return data
    end

  end
end

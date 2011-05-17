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

require 'ronin/model'
require 'ronin/model/has_unique_name'

require 'dm-is-predefined'

module Ronin
  #
  # Represents a Computer Architecture and pre-defines many other common
  # architectures ({i386}, {i486}, {i686}, {i986}, {x86_64}, {ia64}, {ppc},
  # {ppc64}, {sparc}, {sparc64}, {mips_le}, {mips_be}, {arm_le}
  # and {arm_be}).
  #
  class Arch

    include Model
    include Model::HasUniqueName

    is :predefined

    # Primary key
    property :id, Serial

    # Endianness of the architecture
    property :endian, String, :set => ['little', 'big'], :required => true

    # Address length of the architecture
    property :address_length, Integer, :required => true

    #
    # Splats the architecture into multiple variables.
    #
    # @return [Array]
    #   The {#endian} and {#address_length} of the architecture.
    #
    # @example
    #   endian, address_length = Arch.i386
    #   
    #   endian
    #   # => 'little'
    #   address_length
    #   # => 4
    #
    # @since 1.0.0
    #
    # @api public
    #
    def to_ary
      [self.endian, self.address_length]
    end

    #
    # Defines a new pre-defined Arch.
    #
    # @param [Symbol, String] name
    #   The name of the architecture.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Symbol, String] :endian
    #   The endianness of the architecture.
    #
    # @option options [Integer] :address_length
    #   The address-length of the architecture.
    #
    # @example Defining a pre-defined Arch
    #   Arch.predefine :alpha, :endian => :big, :address_length => 8
    #
    # @example Retrieving a pre-defined Arch
    #   Arch.alpha
    #
    # @api private
    #
    def self.predefine(name,options={})
      super(name,options.merge(:name => name))
    end

    # The x86 Architecture
    predefine :x86, :endian => :little, :address_length => 4

    # The x86_64 Architecture
    predefine :x86_64, :endian => :little, :address_length => 8

    # The ia64 Architecture
    predefine :ia64, :endian => :little, :address_length => 8

    # The 32-bit PowerPC Architecture
    predefine :ppc, :endian => :big, :address_length => 4

    # The 64-bit PowerPC Architecture
    predefine :ppc64, :endian => :big, :address_length => 8

    # The 32-bit SPARC Architecture
    predefine :sparc, :endian => :big, :address_length => 4

    # The 64-bit SPARC Architecture
    predefine :sparc64, :endian => :big, :address_length => 8

    # The MIPS (little-endian) Architecture
    predefine :mips_le, :endian => :little, :address_length => 4

    # The MIPS (big-endian) Architecture
    predefine :mips_be, :endian => :big, :address_length => 4

    # The ARM (little-endian) Architecture
    predefine :arm_le, :endian => :little, :address_length => 4

    # The ARM (big-endian) Architecture
    predefine :arm_be, :endian => :big, :address_length => 4

    #
    # @see x86
    #
    def self.i386; x86; end

    #
    # @see x86
    #
    def self.i486; x86; end

    #
    # @see x86
    #
    def self.i686; x86; end

    #
    # @see x86
    #
    def self.i986; x86; end

    #
    # @see mips_be
    #
    def self.mips; mips_be; end

    #
    # @see arm_be
    #
    def self.arm; arm_be; end

  end
end

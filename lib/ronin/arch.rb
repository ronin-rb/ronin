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

require 'ronin/model'

require 'dm-predefined'

module Ronin
  #
  # Represents a Computer Architecture and pre-defines many other common
  # architectures ({i386}, {i486}, {i686}, {i986}, {x86_64}, {ia64}, {ppc},
  # {ppc64}, {sparc}, {sparc64}, {mips_le}, {mips_be}, {arm_le}
  # and {arm_be}).
  #
  class Arch

    include Model
    include DataMapper::Predefined

    # Primary key
    property :id, Serial

    # Name of the architecture
    property :name, String, :required => true, :unique => true

    # Endianness of the architecture
    property :endian, String, :required => true

    # Address length of the architecture
    property :address_length, Integer, :required => true

    # Validates
    validates_format :endian, :with => lambda { |endian|
      endian == 'big' || endian == 'little'
    }
    validates_is_number :address_length

    #
    # Converts the architecture to a String.
    #
    # @return [String]
    #   The name of the architecture.
    #
    def to_s
      self.name.to_s
    end

    #
    # Defines a new builtin Arch.
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
    # @example Defining a builtin Arch
    #   Arch.predefine :alpha, :endian => :big, :address_length => 8
    #
    # @example Retrieving a predefined Arch
    #   Arch.alpha
    #
    def self.predefine(name,options={})
      super(name,options.merge(:name => name))
    end

    # The i386 Architecture
    predefine :i386, :endian => :little, :address_length => 4

    # The i486 Architecture
    predefine :i486, :endian => :little, :address_length => 4

    # The i686 Architecture
    predefine :i686, :endian => :little, :address_length => 4

    # The i986 Architecture
    predefine :i986, :endian => :little, :address_length => 4

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

  end
end

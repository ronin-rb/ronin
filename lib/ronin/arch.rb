#
#--
# Ronin - A ruby development platform designed for information security
# and data exploration tasks.
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

require 'og'

module Ronin
  class Arch

    COMMON_ENDIAN = 'little' # Common architecture endian

    COMMON_ADDRESS_LENGTH = 4 # Common architecture address length

    # Name of the architecture
    attr_accessor :name, String, :unique => true

    # Endianness of the architecture
    attr_accessor :endian, String

    # Address length of the architecture
    attr_accessor :address_length, Integer

    #
    # Creates a new Arch object with the specified _name_ and the given
    # _endian_ and _address_length_. _endian_ defaults to :little and
    # _address_length_ defaults to 4. If _block_ is given, it will be
    # passed the newly created Arch object.
    #
    #   Arch.new('i686')
    #
    #   Arch.new('amd64','little',8)
    #
    #   Arch.new('ppc64') do |arch|
    #     arch.endian = 'big'
    #     arch.address_length = 8
    #   end
    #
    def initialize(name,endian=COMMON_ENDIAN,address_length=COMMON_ADDRESS_LENGTH,&block)
      @name = name.to_s
      @endian = endian.to_s
      @address_length = address_length

      block.call(self) if block
    end

    #
    # Returns +true+ if the arch has the same name, endian and
    # address_length as the _other_ arch, returns +false+ otherwise.
    #
    def ==(other)
      return false unless @name==other.name
      return false unless @endian==other.endian
      return @address_length==other.address_length
    end

    #
    # Returns the name of the arch as a String.
    #
    def to_s
      @name.to_s
    end

    #
    # Provides the builtin Arch objects.
    #
    def Arch.builtin
      @@builtin ||= {}
    end

    #
    # Defines a new builtin Arch with the specified _name_ and the given
    # _opts_. If _block_ is given, it will be passed the newly created
    # Arch.
    #
    def Arch.define(name,opts={},&block)
      name = name.to_sym

      return Arch.builtin[name] = Arch.new(name,opts[:endian],opts[:address_length],&block)
    end

    define :i386, :endian => :little, :address_length => 4
    define :i486, :endian => :little, :address_length => 4
    define :i686, :endian => :little, :address_length => 4
    define :i986, :endian => :little, :address_length => 4
    define :x86_64, :endian => :little, :address_length => 8
    define :ia64, :endian => :little, :address_length => 8
    define :ppc, :endian => :big, :address_length => 4
    define :ppc64, :endian => :big, :address_length => 8
    define :sparc, :endian => :big, :address_length => 4
    define :sparc64, :endian => :big, :address_length => 8
    define :mips_le, :endian => :little, :address_length => 4
    define :mips_be, :endian => :big, :address_length => 4
    define :arm_le, :endian => :little, :address_length => 4
    define :arm_be, :endian => :big, :address_length => 4

  end
end

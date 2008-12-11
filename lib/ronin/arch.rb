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

require 'ronin/extensions/meta'
require 'ronin/extensions/string'
require 'ronin/model'

module Ronin
  class Arch

    include Model

    property :id, Serial

    # Name of the architecture
    property :name, String

    # Endianness of the architecture
    property :endian, String

    # Address length of the architecture
    property :address_length, Integer

    # Validates
    validates_present :name, :endian, :address_length
    validates_is_unique :name
    validates_format :endian, :with => lambda { |endian|
      endian == 'big' || endian == 'little'
    }
    validates_is_number :address_length

    #
    # Returns the name of the arch as a String.
    #
    def to_s
      @name.to_s
    end

    #
    # Defines a new builtin Arch with the specified _name_ and the given
    # _options_.
    #
    def Arch.define(name,options={})
      name = name.to_s
      endian = options[:endian].to_s
      address_length = options[:address_length].to_i

      meta_def(name.to_method_name) do
        Arch.first_or_create(
          :name => name,
          :endian => endian,
          :address_length => address_length
        )
      end

      return nil
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

#
#--
# Ronin - A Ruby platform designed for information security and data
# exploration tasks.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'dm-predefined'

module Ronin
  class Arch

    include Model
    include DataMapper::Predefined

    # Primary key
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
    def self.predefine(name,options={})
      super(name,options.merge(:name => name))
    end

    predefine :i386, :endian => :little, :address_length => 4
    predefine :i486, :endian => :little, :address_length => 4
    predefine :i686, :endian => :little, :address_length => 4
    predefine :i986, :endian => :little, :address_length => 4
    predefine :x86_64, :endian => :little, :address_length => 8
    predefine :ia64, :endian => :little, :address_length => 8
    predefine :ppc, :endian => :big, :address_length => 4
    predefine :ppc64, :endian => :big, :address_length => 8
    predefine :sparc, :endian => :big, :address_length => 4
    predefine :sparc64, :endian => :big, :address_length => 8
    predefine :mips_le, :endian => :little, :address_length => 4
    predefine :mips_be, :endian => :big, :address_length => 4
    predefine :arm_le, :endian => :little, :address_length => 4
    predefine :arm_be, :endian => :big, :address_length => 4

  end
end

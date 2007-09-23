#
# Ronin - A decentralized repository for the storage and sharing of computer
# security advisories, exploits and payloads.
#
# Copyright (c) 2007 Hal Brodigan (postmodern at users.sourceforge.net)
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

require 'og'

module Ronin
  class Arch

    # Name of the architecture
    attr_reader :name, String, :unique => true

    # Endianness of the architecture
    attr_reader :endian, String

    # Address length of the architecture
    attr_reader :address_length, Integer

    def initialize(name,endian,address_length)
      @name = name.to_s
      @endian = endian.to_s
      @address_length = address_length
    end

    def ==(other)
      return false unless @name==other.name
      return false unless @endian==other.endian
      return @address_length==other.address_length
    end

    def to_s
      @name.to_s
    end

    def self.define(name,opts={:endian => :little, :address_length => 4})
      arch(name,opts)
    end

    protected

    def self.builtin
      @@builtin ||= {}
    end

    def Object.arch(name,opts={:endian => :little, :address_length => 4})
      builtin[name.to_sym] = Arch.new(name,opts[:endian],opts[:address_length])
    end

    arch :x86, :endian => :little, :address_length => 4
    arch :amd64, :endian => :little, :address_length => 8
    arch :ia64, :endian => :little, :address_length => 8
    arch :ppc, :endian => :big, :address_length => 4
    arch :ppc64, :endian => :big, :address_length => 8
    arch :sparc, :endian => :big, :address_length => 4
    arch :sparc64, :endian => :big, :address_length => 8
    arch :mips_le, :endian => :little, :address_length => 4
    arch :mips_be, :endian => :big, :address_length => 4
    arch :arm_le, :endian => :little, :address_length => 4
    arch :arm_be, :endian => :big, :address_length => 4

    def self.const_missing(name)
      name = name.to_s.downcase

      return find_by_name(name) || builtin[name.to_sym]
    end

  end
end

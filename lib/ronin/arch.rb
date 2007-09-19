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
    attr_reader :arch, String, :unique => true

    # Endianness of the architecture
    attr_reader :endian, String

    # Address length of the architecture
    attr_reader :address_length, Integer

    def initialize(arch,endian,address_length)
      @arch = arch.to_s
      @endian = endian.to_sym
      @address_length = address_length

      Arch.archs[@arch] = self
    end

    def ==(other)
      return false unless @arch==other.arch
      return false unless @endian==other.endian
      return @address_length==other.address_length
    end

    def Arch.archs
      @@archs ||= {}
    end

    def Arch.exists?(name)
      Arch.archs.has_key?(name.to_s)
    end

    def Arch.all(&block)
      archs.each_value(&block)
    end

    X86 = Arch.new('x86',:little_endian,4)
    AMD64 = Arch.new('amd64',:little_endian,8)
    IA64 = Arch.new('ia64',:little_endian,8)
    PPC = Arch.new('ppc',:big_endian,4)
    PPC64 = Arch.new('ppc64',:big_endian,8)
    SPARC = Arch.new('sparc',:big_endian,4)
    SPARC64 = Arch.new('sparc64',:big_endian,8)
    MIPS_LITTLE = Arch.new('mips_le',:little_endian,4)
    MIPS_BIG = Arch.new('mips_be',:big_endian,4)
    ARM_LITTLE = Arch.new('arm_le',:little_endian,4)
    ARM_BIG = Arch.new('arm_be',:big_endian,4)

  end
end

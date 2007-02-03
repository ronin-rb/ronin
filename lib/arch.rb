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

module Ronin

  LITTLE_ENDIAN = 0
  BIG_ENDIAN = 1

  class Arch

    # Name of the architecture
    attr_reader :arch

    # Endianness of the architecture
    attr_reader :endian

    # Address length of the architecture
    attr_reader :address_length

    def initialize(arch,endian,address_length)
      @arch = arch
      @endian = endian
      @address_length = address_length
    end

  end

  ARCH_X86 = Arch.new("x86",LITTLE_ENDIAN,4)
  ARCH_AMD64 = Arch.new("amd64",LITTLE_ENDIAN,8)
  ARCH_IA64 = Arch.new("ia64",LITTLE_ENDIAN,8)
  ARCH_PPC = Arch.new("ppc",BIG_ENDIAN,4)
  ARCH_PPC64 = Arch.new("ppc64",BIG_ENDIAN,8)
  ARCH_SPARC = Arch.new("sparc",BIG_ENDIAN,4)
  ARCH_SPARC64 = Arch.new("sparc64",BIG_ENDIAN,8)
  ARCH_MIPS_LE = Arch.new("mips LE",LITTLE_ENDIAN,4)
  ARCH_MIPS_BE = Arch.new("mips BE",BIG_ENDIAN,4)
  ARCH_ARM_LE = Arch.new("arm LE",LITTLE_ENDIAN,4)
  ARCH_ARM_BE = Arch.new("arm BE",BIG_ENDIAN,4)

end

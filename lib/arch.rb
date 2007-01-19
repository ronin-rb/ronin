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

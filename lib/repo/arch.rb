require 'arch'
require 'platform'

module Ronin
  class Arch

    # Name of the architecture
    attr_reader :arch, String, :unique => true

    # Endianness of the architecture
    attr_reader :endian, Integer

    # Address length of the architecture
    attr_reader :address_length, Integer

  end
end

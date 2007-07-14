require 'arch'

module Ronin
  class Arch

    property :arch, String, :unique => true

    property :endian, Integer

    property :address_length, Integer

  end
end

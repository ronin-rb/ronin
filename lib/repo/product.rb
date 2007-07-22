require 'product'

module Ronin
  class Product

    # Name
    attr_reader :name, String

    # Version
    attr_reader :version, String

    # Venders
    attr_reader :vendor, String

  end
end

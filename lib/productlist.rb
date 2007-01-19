module Ronin
  class Product

    # Name
    attr_reader :name

    # Version
    attr_reader :version

    # Venders
    attr_reader :vendor

    def initialize(name,version,vendor)
      @name = name
      @version = version
      @vendor = vendor
    end

  end

  class ProductSupport

    # Name
    attr_reader :name

    # Version
    attr_reader :version

    # Venders
    attr_reader :vendors

    def initialize(name,version,vendors=[])
      @name = name
      @version = version
      @vendors = vendors
    end

    def supported?(product)
      return false if @name!=product.name
      return false if @version!=product.version
      return false if (@venders & [product.vendor]).empty?
      return true
    end

  end

  class ProductList < Array

    def contains?(product)
      self.each do |support|
	break true if support.supported(product)
      end
    end

  end
end

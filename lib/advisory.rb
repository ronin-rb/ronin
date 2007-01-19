require 'productlist'

module Ronin
  class Advisory

    # Vulnerability classification.
    attr_reader :class

    # CVE
    attr_reader :cve

    # Remote?
    attr_reader :remote

    # Local?
    attr_reader :local

    # Date published
    attr_reader :published

    # Date updated
    attr_reader :updated

    # Discovery credit
    attr_reader :credits

    # Vulnerable products
    attr_reader :products

    # Comments on the vulnerability.
    attr_reader :comments

    def initialize
      @products = ProductList.new
    end

  end
end

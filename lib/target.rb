require 'platform'

module Ronin
  class Target

    # Targeted product version
    attr_reader :product_version

    # Targeted platform
    attr_reader :platform

    # Target comments
    attr_reader :comments

    def initialize(product_version,platform,comments=nil)
      @product_version = product_version
      @platform = platform
      @comments = comments
    end

  end
end

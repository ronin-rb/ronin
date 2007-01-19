require 'parameters'

module Ronin
  class Payload

    # payload parameters
    attr_accessor :params

    # payload data
    attr_accessor :data

    def initialize
      @params = Parameters.new
      @data = nil
    end

    def build!
      if block_given?
	@data = ""
	yield self
      end
    end

  end
end

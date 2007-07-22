require 'platform'

module Ronin
  class Platform

    # Name of the Operating System
    attr_reader :os, String

    # Version of the Operating System
    attr_reader :version, String

    # Architecture of the Platform
    has_many :arch

  end
end

require 'platform'

module Ronin
  class Platform

    property :os, String

    property :version, String

    property :arch, Arch

  end
end

require 'ronin/network/helpers/helper'

module TestHelper
  include Network::Helpers::Helper

  def connect
    require_variable :host

    return @host
  end
end

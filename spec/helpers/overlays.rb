require 'ronin/overlay'

module Helpers
  module Overlays
    OVERLAYS_DIR = File.expand_path(File.join(File.dirname(__FILE__),'overlays'))

    def load_overlay(name)
      Overlay.first(:name => name)
    end
  end
end

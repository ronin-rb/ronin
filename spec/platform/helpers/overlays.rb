require 'helpers/database'

module Helpers
  module Overlays
    OVERLAYS_DIR = File.expand_path(File.join(File.dirname(__FILE__),'overlays'))

    OVERLAYS = Dir[File.join(OVERLAYS_DIR,'*')].each do |path|
      Platform::Overlay.create(:path => path)
    end

    def load_overlay(name)
      Platform::Overlay.first(:name => name)
    end
  end
end

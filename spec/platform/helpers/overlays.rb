require 'helpers/database'

module Helpers
  module Overlays
    OVERLAYS_DIR = File.expand_path(File.join(File.dirname(__FILE__),'overlays'))

    Platform::Overlay.create!(
      :path => File.join(OVERLAYS_DIR,'hello')
    )

    Platform::Overlay.create!(
      :path => File.join(OVERLAYS_DIR,'random'),
      :uri => 'git@github.com:/path/to/random.git',
      :installed => true
    )

    Platform::Overlay.create!(
      :path => File.join(OVERLAYS_DIR,'test1'),
      :uri => 'git@github.com:/path/to/test1.git'
    )

    Platform::Overlay.create!(
      :path => File.join(OVERLAYS_DIR,'test2'),
      :uri => 'git@github.com:/path/to/test2.git'
    )

    def load_overlay(name)
      Platform::Overlay.first(:name => name)
    end
  end
end

require 'helpers/database'

module Helpers
  module Overlays
    OVERLAYS_DIR = File.expand_path(File.join(File.dirname(__FILE__),'overlays'))

    Platform::Overlay.create!(
      :path => File.join(OVERLAYS_DIR,'hello'),
      :name => 'hello',
      :host => Platform::Overlay::DEFAULT_HOST
    )

    Platform::Overlay.create!(
      :path => File.join(OVERLAYS_DIR,'random'),
      :uri => 'git@github.com/path/to/random.git',
      :installed => true,
      :name => 'random',
      :host => 'github.com'
    )

    Platform::Overlay.create!(
      :path => File.join(OVERLAYS_DIR,'test1'),
      :uri => 'git@github.com/path/to/test1.git',
      :name => 'test1',
      :host => 'github.com'
    )

    Platform::Overlay.create!(
      :path => File.join(OVERLAYS_DIR,'test2'),
      :uri => 'git@github.com/path/to/test2.git',
      :name => 'test2',
      :host => 'github.com'
    )

    def load_overlay(name)
      Platform::Overlay.first(:name => name)
    end
  end
end

require 'rspec'
require 'model/models'
require 'helpers/overlays'

require 'ronin/spec/database'

include Ronin

RSpec.configure do |spec|
  spec.before(:suite) do
    DataMapper.auto_migrate!

    Overlay.create(
      :path => File.join(Helpers::Overlays::OVERLAYS_DIR,'hello'),
      :name => 'hello',
      :domain => Overlay::LOCAL_DOMAIN
    )

    Overlay.create(
      :path => File.join(Helpers::Overlays::OVERLAYS_DIR,'random'),
      :uri => 'git@github.com/path/to/random.git',
      :installed => true,
      :name => 'random',
      :domain => 'github.com'
    )

    Overlay.create(
      :path => File.join(Helpers::Overlays::OVERLAYS_DIR,'test1'),
      :uri => 'git@github.com/path/to/test1.git',
      :name => 'test1',
      :domain => 'github.com'
    )

    Overlay.create(
      :path => File.join(Helpers::Overlays::OVERLAYS_DIR,'test2'),
      :uri => 'git@github.com/path/to/test2.git',
      :name => 'test2',
      :domain => 'github.com'
    )
  end
end

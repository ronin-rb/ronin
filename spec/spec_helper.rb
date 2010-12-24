require 'rspec'
require 'helpers/repositories'

require 'ronin/spec/database'

include Ronin

RSpec.configure do |spec|
  spec.before(:suite) do
    Repository.create(
      :path => File.join(Helpers::Repositories::DIR,'hello'),
      :name => 'hello',
      :domain => Repository::LOCAL_DOMAIN
    )

    Repository.create(
      :path => File.join(Helpers::Repositories::DIR,'random'),
      :uri => 'git@github.com/path/to/random.git',
      :installed => true,
      :name => 'random',
      :domain => 'github.com'
    )

    Repository.create(
      :path => File.join(Helpers::Repositories::DIR,'test1'),
      :uri => 'git@github.com/path/to/test1.git',
      :name => 'test1',
      :domain => 'github.com'
    )

    Repository.create(
      :path => File.join(Helpers::Repositories::DIR,'test2'),
      :uri => 'git@github.com/path/to/test2.git',
      :name => 'test2',
      :domain => 'github.com'
    )
  end
end

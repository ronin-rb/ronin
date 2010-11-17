require 'ronin/engine'
require 'ronin/engine/buildable'

class BuildableClass

  include Ronin::Engine
  include Ronin::Engine::Buildable

  property :id, Serial

  parameter :var, :default => 'world'

  attr_reader :output

end

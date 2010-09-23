require 'ronin/engine'
require 'ronin/engine/buildable'

class BuildableClass

  include Ronin::Engine
  include Ronin::Engine::Buildable

  parameter :var, :default => 'world'

  attr_reader :output

end

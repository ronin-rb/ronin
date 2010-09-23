require 'ronin/engine'
require 'ronin/engine/buildable'

class BuildableClass

  include Engine
  include Engine::Buildable

  parameter :var, :default => 'world'

  attr_reader :output

end

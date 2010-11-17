require 'ronin/engine'
require 'ronin/engine/deployable'

class DeployableClass

  include Ronin::Engine
  include Ronin::Engine::Deployable

  property :id, Serial

  parameter :var, :default => 5

end

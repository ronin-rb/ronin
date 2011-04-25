require 'ronin/script'
require 'ronin/script/deployable'

class DeployableClass

  include Ronin::Script
  include Ronin::Script::Deployable

  property :id, Serial

  parameter :var, :default => 5

end

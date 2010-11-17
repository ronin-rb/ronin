require 'ronin/engine'
require 'ronin/engine/verifiable'

class VerifiableClass

  include Ronin::Engine
  include Ronin::Engine::Verifiable

  property :id, Serial

  parameter :var

  def initialize(attributes={},&block)
    super(attributes)

    instance_eval(&block) if block
  end

end

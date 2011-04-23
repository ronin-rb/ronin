require 'ronin/engine'
require 'ronin/engine/testable'

class TestableClass

  include Ronin::Engine
  include Ronin::Engine::Testable

  property :id, Serial

  parameter :var

  def initialize(attributes={},&block)
    super(attributes)

    instance_eval(&block) if block
  end

end

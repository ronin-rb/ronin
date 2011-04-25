require 'ronin/script'
require 'ronin/script/testable'

class TestableClass

  include Ronin::Script
  include Ronin::Script::Testable

  property :id, Serial

  parameter :var

  def initialize(attributes={},&block)
    super(attributes)

    instance_eval(&block) if block
  end

end

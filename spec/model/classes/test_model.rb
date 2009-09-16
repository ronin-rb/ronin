require 'ronin/model/model'

class TestModel

  include Ronin::Model

  property :id, Serial

  property :name, String

  attr_reader :var

  def initialize(attributes={})
    super(attributes)

    @var = 2
  end

end

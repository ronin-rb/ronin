require 'ronin/model/model'

require 'model/classes/basic_model'

class CustomModel < BasicModel

  include Ronin::Model

  attr_reader :var

  def initialize(attributes={})
    super(attributes)

    @var = 2
  end

end

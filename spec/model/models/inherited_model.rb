require 'ronin/model/model'
require_relative 'base_model'

class InheritedModel < BaseModel

  include Ronin::Model

  attr_reader :var

  def initialize(attributes={})
    super(attributes)

    @var = 2
  end

end

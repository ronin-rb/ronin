require 'ronin/model/model'

class BaseModel

  include Ronin::Model

  property :id, Serial

  property :name, String

  property :age, Integer

end

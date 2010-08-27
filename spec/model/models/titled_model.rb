require 'ronin/model/has_title'

class TitledModel

  include Ronin::Model
  include Ronin::Model::HasTitle

  property :id, Serial

end

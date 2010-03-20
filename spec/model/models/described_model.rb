require 'ronin/model/has_description'

class DescribedModel

  include Ronin::Model
  include Ronin::Model::HasDescription

  property :id, Serial

end

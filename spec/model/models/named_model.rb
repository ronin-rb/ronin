require 'ronin/model/has_name'

class NamedModel

  include Ronin::Model
  include Ronin::Model::HasName

  property :id, Serial

end

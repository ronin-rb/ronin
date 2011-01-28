require 'ronin/model/has_version'

class VersionedModel

  include Ronin::Model
  include Ronin::Model::HasVersion

  property :id, Serial

  property :content, String

end

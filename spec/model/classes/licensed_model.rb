require 'ronin/model/has_license'

class LicensedModel

  include Model
  include Model::HasLicense

  property :id, Serial

  property :content, String

end

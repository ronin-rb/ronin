require 'ronin/has_license'

class LicensedModel

  include Model
  include HasLicense

  property :id, Serial

  property :content, String

end

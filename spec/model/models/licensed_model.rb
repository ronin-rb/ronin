require 'ronin/model/has_license'

class LicensedModel

  include Ronin::Model::HasLicense

  property :id, Serial

  property :content, String

end

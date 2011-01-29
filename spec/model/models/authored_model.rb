require 'ronin/model/has_authors'

class AuthoredModel

  include Ronin::Model::HasAuthors

  property :id, Serial

  property :content, String

end

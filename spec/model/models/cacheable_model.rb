require 'ronin/model/cacheable'

class CacheableModel

  include Ronin::Model::Cacheable

  property :id, Serial

  property :content, String, :required => true

  attr_accessor :var

end

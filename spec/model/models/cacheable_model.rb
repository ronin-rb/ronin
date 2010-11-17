require 'ronin/model/cacheable'

class CacheableModel

  include Ronin::Model::Cacheable

  contextify :ronin_cacheable_model

  property :id, Serial

  property :content, String, :required => true

  attr_accessor :var

end

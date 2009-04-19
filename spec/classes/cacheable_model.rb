require 'ronin/cacheable'

class CacheableModel

  include Ronin::Cacheable

  contextify :ronin_cacheable_model

  property :id, Serial

  property :content, String

  attr_accessor :config

end

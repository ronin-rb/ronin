require 'ronin/platform/cacheable'

class CacheableModel

  include Ronin::Platform::Cacheable

  contextify :ronin_cacheable_model

  property :id, Serial

  property :content, String

  attr_accessor :var

end

require 'model/models/cacheable_model'

CacheableModel.object do

  cache do
    self.content = 'this is a NoMethodError test'
  end

end

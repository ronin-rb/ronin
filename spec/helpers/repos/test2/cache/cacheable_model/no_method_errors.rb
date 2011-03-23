require 'model/models/cacheable_model'

CacheableModel.objectttttt do

  cache do
    self.content = 'this is a NoMethodError test'
  end

end

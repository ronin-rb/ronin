require 'platform/classes/cacheable_model'

onin_cacheable_model do

  cache do
    self.content = 'this is a NoMethodError test'
  end

end

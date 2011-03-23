require 'model/models/cacheable_model'

CacheableModel.object do

  @var = 1

  cache do
    self.content = 'this is test one'
  end

  def greeting
    'hello'
  end

end

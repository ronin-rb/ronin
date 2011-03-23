require 'model/models/cacheable_model'

CacheableModel.object do

  @var = 2

  cache do
    self.content = 'this is test two'
  end

  def greeting
    'hello'
  end

end

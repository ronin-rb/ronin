require 'model/models/cacheable_model'

ronin_cacheable_model do

  @var = 2

  cache do
    self.content = 'this is test two'
  end

  def greeting
    'hello'
  end

end

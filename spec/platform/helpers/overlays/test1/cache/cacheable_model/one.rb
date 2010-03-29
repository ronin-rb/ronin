require 'platform/classes/cacheable_model'

ronin_cacheable_model do

  @config = true

  cache do
    self.content = 'this is test one'
  end

  def greeting
    'hello'
  end

end

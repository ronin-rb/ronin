require 'model/models/cacheable_model'

MyScript.object do

  @y = @x * 2

  cache do
    self.name = 'two'
    self.content = 'this is test two'
  end

  def greeting
    'hello'
  end

end

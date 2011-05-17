require 'classes/my_script'

MyScript.object do

  @var = 2

  cache do
    self.name = 'test'
    self.content = 'this is a test'
  end

  def greeting
    'hello'
  end

end

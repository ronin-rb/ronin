require 'classes/my_script'

MyScript.object do

  @var = 2

  cache do
    self.name = 'one'
    self.content = 'this is test one'
  end

  def greeting
    'hello'
  end

end

require 'classes/my_script'

MyScript.object do

  cache do
    self.name = 'cached'
    self.content = 'example for scripts that are cached'
  end

end

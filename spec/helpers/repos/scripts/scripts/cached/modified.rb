require 'classes/my_script'

MyScript.object do

  cache do
    self.name = 'modified'
    self.content = 'example for scripts that are modified'
  end

end

require 'classes/my_script'

MyScript.object do

  cache do
    self.name = 'unmodified'
    self.content = 'example for scripts that are never modified'
  end

end

require 'classes/my_script'
require 'totally/does/not/exist'

MyScript.object do

  cache do
    self.name = 'load_error'
    self.content = 'this is a LoadError test'
  end

end

require 'classes/my_script'

MyScript.object do

  raise("Exception when caching a file")

  cache do
    self.name = 'exception'
  end

end

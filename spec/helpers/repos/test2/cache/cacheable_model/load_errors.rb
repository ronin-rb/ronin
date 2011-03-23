require 'totally/does/not/exist'

CacheableModel.object do

  cache do
    self.content = 'this is a LoadError test'
  end

end

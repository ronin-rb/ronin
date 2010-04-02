require 'totally/does/not/exist'

ronin_cacheable_model do

  cache do
    self.content = 'this is a LoadError test'
  end

end

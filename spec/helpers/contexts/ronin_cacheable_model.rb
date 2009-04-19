ronin_cacheable_model do

  @config = true

  cache do
    self.content = 'this is a test'
  end

  def greeting
    'hello'
  end

end

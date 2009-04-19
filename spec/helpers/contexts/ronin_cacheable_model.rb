ronin_cacheable_model do

  @config = true

  def cache
    self.content = 'this is a test'
  end

  def greeting
    'hello'
  end

end

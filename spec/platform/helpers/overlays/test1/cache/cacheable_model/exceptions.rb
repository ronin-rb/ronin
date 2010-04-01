require 'platform/classes/cacheable_model'

ronin_cacheable_model do

  cache do
    raise("Exception when caching a file")
  end

end

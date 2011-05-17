require 'classes/my_script'

MyScript.object do

  cache do
    self.name = 'validation_error'

    # intentionally do not set the content property
  end

end

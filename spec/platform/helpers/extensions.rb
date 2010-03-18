module Helpers
  module Extensions
    def extension_path(name)
      File.expand_path(File.join(File.dirname(__FILE__),'extensions',"#{name}.rb"))
    end
  end
end

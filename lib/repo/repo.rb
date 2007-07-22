require 'repo/objectcontext'

module Ronin
  module Repo
    def ronin_load_objects(path)
      ObjectContext.load_objects(path)
    end

    def ronin_load_object(type,path)
      ObjectContext.load_object(type,path)
    end
  end
end

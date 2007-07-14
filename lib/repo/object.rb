require 'repo/extensions/kernel'
require 'repo/extensions/object'
require 'repo/exceptions/objectnotfound'
require 'og'

module Ronin
  module Repo
    def Repo.ronin_load_objects(path)
      unless File.file?(path)
	raise ObjectNotFound, "object context '#{path}' does not exist", caller
      end

      # push on the path to load
      ronin_pending_objects.unshift(path)

      load(path)

      # pop off the path to load
      ronin_pending_objects.shift

      # return the loaded objects
      return ronin_objects
    end

    def Repo.ronin_load_object(type,path,&block)
      obj = ronin_load_object(path)[type.to_sym]
      ronin_objects.clear

      block.call(obj) if block
      return obj
    end
  end
end

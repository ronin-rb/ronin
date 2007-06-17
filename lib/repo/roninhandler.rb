require 'repo/cache'

module Ronin
  def ronin
    RoninHandler.ronin
  end

  class RoninHandler

    def RoninHandler.ronin
      @@ronin ||= RoninHandler.new
    end

    protected

    def method_missing(sym,*args)
      name = sym.id2name

      # return a category if present
      return Repo.cache.category(name) if Repo.cache.has_category?(name)

      raise NoMethodError, name
    end

  end
end

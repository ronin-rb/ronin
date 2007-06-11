require 'repo/cache'

module Ronin
  def ronin
    Ronin.ronin
  end

  class Ronin

    def Ronin.ronin
      @@ronin ||= Ronin.new
    end

    protected

    def method_missing(sym,*args)
      name = sym.id2name

      # return a category if present
      return Repo.category(name) if Repo.has_category?(name)

      raise NoMethodError.new(name)
    end

  end
end

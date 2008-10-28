module Hpricot
  class Tag

    #
    # Returns +true+ if the tag has the same name as the _other_ tag,
    # returns +false+ otherwise.
    #
    def eql?(other)
      self.name == other.name
    end

    alias == eql?

  end
end

require 'hpricot'

module Hpricot
  module Tag

    #
    # Returns +true+ if the tag has the same name as the _other_ tag,
    # returns +false+ otherwise.
    #
    def eql?(other)
      return false unless self.class == other.class

      return self.name == other.name
    end

    alias == eql?

  end
end

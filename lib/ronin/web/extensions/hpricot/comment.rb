require 'hpricot'

module Hpricot
  class Comment

    #
    # Returns +true+ if the comment has the same content the _other_ comment,
    # returns +false+ otherwise.
    #
    def eql?(other)
      return false unless self.class == other.class

      return content == other.content
    end

    alias == eql?

  end
end

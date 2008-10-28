require 'hpricot'

module Hpricot
  class Comment

    #
    # Returns +true+ if the comment has the same content the _other_ comment,
    # returns +false+ otherwise.
    #
    def eql?(other)
      content == other.content
    end

    alias == eql?

  end
end

module Hpricot
  class Text

    #
    # Returns +true+ if the text node has the same content the _other_ text
    # node, returns +false+ otherwise.
    #
    def eql?(other)
      content == other.content
    end

    alias == eql?

  end
end

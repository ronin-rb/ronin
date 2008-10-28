require 'ronin/web/extensions/hpricot/container'

module Hpricot
  class Elem

    #
    # Returns +true+ if the element has the same starting-tag and
    # ending-tag as the _other_ element, returns +false+ otherwise.
    #
    def eql?(other)
      (stag == other.stag && etag == other.etag)
    end

    alias == eql?

  end
end

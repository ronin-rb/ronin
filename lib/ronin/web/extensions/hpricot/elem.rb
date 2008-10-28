require 'ronin/web/extensions/hpricot/container'

require 'hpricot'

module Hpricot
  class Elem

    include Comparable

    #
    # Returns +true+ if the element has the same starting-tag and
    # ending-tag as the _other_ element, returns +false+ otherwise.
    #
    def eql?(other)
      (stag == other.stag && etag == other.etag)
    end

    def ==(other)
      self.eql?(other) && super(other)
    end

  end
end

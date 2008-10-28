require 'ronin/web/extensions/hpricot/container'
require 'ronin/web/extensions/hpricot/tag'
require 'ronin/web/extensions/hpricot/text'
require 'ronin/web/extensions/hpricot/comment'
require 'ronin/web/extensions/hpricot/elem'

module Hpricot
  class Doc

    #
    # Returns +true+ if the documents children match the children of the
    # _other_ document.
    #
    def ==(other)
      children == other.children
    end

  end
end

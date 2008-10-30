require 'hpricot'

module Hpricot
  module Container
    #
    # Iterates over every sub-child, passing each to the specified _block_.
    #
    def every_child(&block)
      each_child do |child|
        block.call(child)

        if child.kind_of?(Hpricot::Container)
          child.every_child(&block)
        end
      end

      return self
    end

    #
    # Iterates over every text node, passing each to the specified _block_.
    #
    def all_text(&block)
      every_child do |child|
        block.call(child) if child.kind_of?(Text)
      end
    end

    #
    # Returns the number of all sub-children.
    #
    def count_children
      sum = 0

      every_child { |child| sum += 1 }
      return sum
    end

    #
    # Compares the number of sub-children with that of the _other_ element.
    #
    def <=>(other)
      count_children <=> other.count_children
    end
  end
end

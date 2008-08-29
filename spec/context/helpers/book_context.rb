require 'ronin/context'

class Book

  include Context

  contextify :book

  # Title of the book
  attr_accessor :title

  # Author of the book
  attr_accessor :author

end

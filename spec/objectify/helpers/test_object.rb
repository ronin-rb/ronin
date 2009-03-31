require 'ronin/objectify'

class TestObject

  include Objectify

  objectify :test

  property :id, Serial

  property :mesg, String

  parameter :x

  parameter :y

end

require 'ronin/script'
require 'ronin/script/buildable'

class BuildableClass

  include Ronin::Script
  include Ronin::Script::Buildable

  property :id, Serial

  parameter :var, :default => 'world'

  attr_reader :output

end

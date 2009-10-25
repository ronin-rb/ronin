require 'spec_helper'

require 'ronin/database'

module Helpers
  Database.setup({ :adapter => 'sqlite3', :database => ':memory:' })
end

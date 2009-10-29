require 'spec_helper'

require 'ronin/database'

module Helpers
  Database.setup('sqlite3::memory:')
end

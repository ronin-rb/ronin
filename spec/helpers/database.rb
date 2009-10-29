require 'spec_helper'

require 'ronin/database'

module Helpers
  Database.setup(ENV['DATABASE'] || 'sqlite3::memory:')
end

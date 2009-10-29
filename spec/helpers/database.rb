require 'ronin/database'

require 'spec_helper'

module Helpers
  Database.setup(ENV['DATABASE'] || 'sqlite3::memory:')
end

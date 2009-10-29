require 'ronin/database'

module Helpers
  Ronin::Database.setup(ENV['DATABASE'] || 'sqlite3::memory:')
end

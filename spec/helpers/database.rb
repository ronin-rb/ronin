require 'ronin/database'
require 'ronin/platform'

require 'spec_helper'

module Helpers
  Database.repositories[:default] = 'sqlite3::memory:'

  Database.setup
end

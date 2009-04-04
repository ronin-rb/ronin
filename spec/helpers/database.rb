require 'spec_helper'

require 'ronin/database'

Database.setup({ :adapter => 'sqlite3', :database => ':memory:' })

require 'rubygems'
gem 'rspec', '>=1.1.3'
require 'spec'

require 'helpers'

require 'ronin/database'

include Ronin

Database.setup({ :adapter => 'sqlite3', :database => ':memory:' })

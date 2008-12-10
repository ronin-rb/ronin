require 'rubygems'
gem 'rspec', '>=1.1.3'
require 'spec'

require 'ronin/version'
require 'ronin/database'

include Ronin

require 'helpers'

Database.setup({ :adapter => 'sqlite3', :database => ':memory:' })

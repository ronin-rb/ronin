require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:runtime, :test)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec'
require 'tempfile'
require 'ronin/database/database'

include Ronin

RSpec.configure do |spec|
  spec.before(:suite) do
    database_file = Tempfile.new('ronin_database').path
    database_uri = Addressable::URI.new(
      :scheme => 'sqlite3',
      :path => database_file
    )

    Database.repositories[:default] = database_uri

    if ENV['DEBUG']
      Database.setup_log(:stream => STDOUT, :level => :debug)
    end

    Database.setup
  end
end

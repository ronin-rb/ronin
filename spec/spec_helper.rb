require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:runtime, :test)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'spec'
require 'ronin/database'

Spec::Runner.configure do |spec|
  include Ronin

  spec.before(:suite) do
    Database.repositories[:default] = 'sqlite3::memory:'

    if ENV['DEBUG']
      Database.setup_log(:stream => STDOUT, :level => :debug)
    end

    Database.setup
  end
end

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :test)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec'
require 'ronin/spec/database'

include Ronin

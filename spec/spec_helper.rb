require 'rspec'
require 'simplecov'
SimpleCov.start

include Ronin

RSpec.configure do |specs|
  specs.filter_run_excluding :integration
end

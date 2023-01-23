require 'rspec'
require 'simplecov'
SimpleCov.start

RSpec.configure do |specs|
  specs.filter_run_excluding :integration
end

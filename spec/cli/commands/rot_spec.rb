require 'spec_helper'
require 'ronin/cli/commands/rot'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Rot do
  include_examples "man_page"
end

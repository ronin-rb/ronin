require 'spec_helper'
require 'ronin/cli/commands/irb'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Irb do
  include_examples "man_page"
end

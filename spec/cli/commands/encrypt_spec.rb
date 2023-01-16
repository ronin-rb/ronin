require 'spec_helper'
require 'ronin/cli/commands/encrypt'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Encrypt do
  include_examples "man_page"
end

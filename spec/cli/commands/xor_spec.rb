require 'spec_helper'
require 'ronin/cli/commands/xor'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Xor do
  include_examples "man_page"
end

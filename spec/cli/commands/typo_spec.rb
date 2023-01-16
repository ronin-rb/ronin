require 'spec_helper'
require 'ronin/cli/commands/typo'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Typo do
  include_examples "man_page"
end

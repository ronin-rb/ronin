require 'spec_helper'
require 'ronin/cli/commands/highlight'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Highlight do
  include_examples "man_page"
end

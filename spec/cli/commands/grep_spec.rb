require 'spec_helper'
require 'ronin/cli/commands/grep'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Grep do
  include_examples "man_page"
end

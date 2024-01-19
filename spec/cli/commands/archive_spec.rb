require 'spec_helper'
require 'ronin/cli/commands/archive'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Archive do
  include_examples "man_page"
end

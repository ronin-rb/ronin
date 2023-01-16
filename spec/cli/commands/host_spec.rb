require 'spec_helper'
require 'ronin/cli/commands/host'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Host do
  include_examples "man_page"
end

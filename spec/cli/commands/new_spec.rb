require 'spec_helper'
require 'ronin/cli/commands/new'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::New do
  include_examples "man_page"
end

require 'spec_helper'
require 'ronin/cli/commands/unarchive'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Unarchive do
  include_examples "man_page"
end

require 'spec_helper'
require 'ronin/cli/commands/hexdump'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Hexdump do
  include_examples "man_page"
end

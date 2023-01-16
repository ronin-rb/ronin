require 'spec_helper'
require 'ronin/cli/commands/ip'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Ip do
  include_examples "man_page"
end

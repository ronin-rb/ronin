require 'spec_helper'
require 'ronin/cli/commands/decrypt'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Decrypt do
  include_examples "man_page"
end

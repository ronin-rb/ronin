require 'spec_helper'
require 'ronin/cli/commands/sha256'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Sha256 do
  include_examples "man_page"
end

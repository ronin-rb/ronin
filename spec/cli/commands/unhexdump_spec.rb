require 'spec_helper'
require 'ronin/cli/commands/unhexdump'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Unhexdump do
  include_examples "man_page"
end

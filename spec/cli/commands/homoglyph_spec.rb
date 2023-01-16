require 'spec_helper'
require 'ronin/cli/commands/homoglyph'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Homoglyph do
  include_examples "man_page"
end

require 'spec_helper'
require 'ronin/cli/commands/entropy'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Entropy do
  include_examples "man_page"
end

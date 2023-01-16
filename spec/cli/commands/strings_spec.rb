require 'spec_helper'
require 'ronin/cli/commands/strings'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Strings do
  include_examples "man_page"
end

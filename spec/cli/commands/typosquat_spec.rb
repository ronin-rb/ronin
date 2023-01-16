require 'spec_helper'
require 'ronin/cli/commands/typosquat'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Typosquat do
  include_examples "man_page"
end

require 'spec_helper'
require 'ronin/cli/commands/extract'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Extract do
  include_examples "man_page"
end

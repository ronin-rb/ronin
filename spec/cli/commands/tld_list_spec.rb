require 'spec_helper'
require 'ronin/cli/commands/tld_list'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::TldList do
  include_examples "man_page"
end

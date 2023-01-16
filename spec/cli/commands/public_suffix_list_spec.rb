require 'spec_helper'
require 'ronin/cli/commands/public_suffix_list'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::PublicSuffixList do
  include_examples "man_page"
end

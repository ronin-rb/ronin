require 'spec_helper'
require 'ronin/cli/commands/proxy'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Proxy do
  include_examples "man_page"
end

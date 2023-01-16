require 'spec_helper'
require 'ronin/cli/commands/dns'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Dns do
  include_examples "man_page"
end

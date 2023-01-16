require 'spec_helper'
require 'ronin/cli/commands/netcat'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Netcat do
  include_examples "man_page"
end

require 'spec_helper'
require 'ronin/cli/commands/http'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Http do
  include_examples "man_page"
end

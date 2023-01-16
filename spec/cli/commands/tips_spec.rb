require 'spec_helper'
require 'ronin/cli/commands/tips'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Tips do
  include_examples "man_page"
end

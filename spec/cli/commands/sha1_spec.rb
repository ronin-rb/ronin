require 'spec_helper'
require 'ronin/cli/commands/sha1'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Sha1 do
  include_examples "man_page"
end

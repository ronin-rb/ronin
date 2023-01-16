require 'spec_helper'
require 'ronin/cli/commands/sha512'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Sha512 do
  include_examples "man_page"
end

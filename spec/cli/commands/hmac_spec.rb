require 'spec_helper'
require 'ronin/cli/commands/hmac'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Hmac do
  include_examples "man_page"
end

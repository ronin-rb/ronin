require 'spec_helper'
require 'ronin/cli/commands/url'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Url do
  include_examples "man_page"
end

require 'spec_helper'
require 'ronin/cli/commands/banner_grab'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::BannerGrab do
  include_examples "man_page"
end

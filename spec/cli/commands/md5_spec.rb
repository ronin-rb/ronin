require 'spec_helper'
require 'ronin/cli/commands/md5'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Md5 do
  include_examples "man_page"
end

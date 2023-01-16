require 'spec_helper'
require 'ronin/cli/commands/new/project'
require_relative '../man_page_example'

describe Ronin::CLI::Commands::New::Project do
  include_examples "man_page"
end

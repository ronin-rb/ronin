require 'spec_helper'
require 'ronin/cli/commands/new/script'
require_relative '../man_page_example'

describe Ronin::CLI::Commands::New::Script do
  include_examples "man_page"
end

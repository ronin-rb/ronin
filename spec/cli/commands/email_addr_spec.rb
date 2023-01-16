require 'spec_helper'
require 'ronin/cli/commands/email_addr'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::EmailAddr do
  include_examples "man_page"
end

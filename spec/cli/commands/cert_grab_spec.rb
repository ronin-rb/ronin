require 'spec_helper'
require 'ronin/cli/commands/cert_grab'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::CertGrab do
  include_examples "man_page"
end

require 'spec_helper'
require 'ronin/cli/commands/cert_gen'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::CertGen do
  include_examples "man_page"
end

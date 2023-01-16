require 'spec_helper'
require 'ronin/cli/commands/cert_dump'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::CertDump do
  include_examples "man_page"
end

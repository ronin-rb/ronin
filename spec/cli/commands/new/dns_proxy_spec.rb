require 'spec_helper'
require 'ronin/cli/commands/new/dns_proxy'
require_relative '../man_page_example'

describe Ronin::CLI::Commands::New::DnsProxy do
  include_examples "man_page"
end

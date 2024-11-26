require 'spec_helper'
require 'ronin/cli/commands/new/dns_listener'

describe Ronin::CLI::Commands::New::DnsListener do
  describe "command_name" do
    subject { described_class }

    it do
      expect(subject.command_name).to eq('dns-listener')
    end
  end
end

require 'spec_helper'
require 'ronin/cli/commands/new/http_listener'

describe Ronin::CLI::Commands::New::HttpListener do
  describe "command_name" do
    subject { described_class }

    it do
      expect(subject.command_name).to eq('http-listener')
    end
  end
end

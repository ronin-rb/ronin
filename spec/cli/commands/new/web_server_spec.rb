require 'spec_helper'
require 'ronin/cli/commands/new/web_server'

describe Ronin::CLI::Commands::New::WebServer do
  describe "command_name" do
    subject { described_class }

    it do
      expect(subject.command_name).to eq('web-server')
    end
  end
end

require 'spec_helper'
require 'ronin/cli/commands/new/payload'

describe Ronin::CLI::Commands::New::Payload do
  describe "command_name" do
    subject { described_class }
    it do
      expect(subject.command_name).to eq('payload')
    end
  end
end

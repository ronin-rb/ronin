require 'spec_helper'
require 'ronin/cli/commands/new/nokogiri'

describe Ronin::CLI::Commands::New::Nokogiri do
  describe "command_name" do
    subject { described_class }

    it do
      expect(subject.command_name).to eq('nokogiri')
    end
  end
end

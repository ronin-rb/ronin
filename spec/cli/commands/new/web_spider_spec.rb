require 'spec_helper'
require 'ronin/cli/commands/new/web_spider'

describe Ronin::CLI::Commands::New::WebSpider do
  describe "command_name" do
    subject { described_class }

    it do
      expect(subject.command_name).to eq('web-spider')
    end
  end
end

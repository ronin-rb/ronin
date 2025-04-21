require 'spec_helper'
require 'ronin/cli/commands/new/web_app'

describe Ronin::CLI::Commands::New::WebApp do
  describe "command_name" do
    subject { described_class }

    it do
      expect(subject.command_name).to eq('web-app')
    end
  end
end

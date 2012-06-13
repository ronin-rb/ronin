require 'spec_helper'
require 'ronin/ui/cli/cli'

describe UI::CLI do
  describe "commands" do
    subject { described_class.commands }

    it { should_not be_empty }

    it "should replace '/' characters with a ':'" do
      subject.all? { |command| command.include?('/') }.should be_false
    end
  end

  describe "command" do
    it "should load classes from 'ronin/ui/cli/commands/'" do
      command = subject.command('help')
      
      command.name.should == 'Ronin::UI::CLI::Commands::Help'
    end

    it "should load classes from namespaces within 'ronin/ui/cli/commands/'" do
      command = subject.command('net:proxy')
      
      command.name.should == 'Ronin::UI::CLI::Commands::Net::Proxy'
    end

    it "should raise UnknownCommand for unknown commands" do
      lambda {
        subject.command('foo')
      }.should raise_error(described_class::UnknownCommand)
    end
  end
end

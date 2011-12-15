require 'spec_helper'
require 'ronin/ui/cli/command'

require 'ui/cli/classes/test_command'

describe UI::CLI::Command do
  subject { TestCommand }

  it "should have a command name" do
    subject.command_name.should == 'test_command'
  end

  it "should allow running the command with options" do
    command = subject.run({:foo => true})

    command.foo.should == true
  end

  it "should have zero indentation by default" do
    command = subject.new
    command.instance_variable_get('@indent').should == 0
  end
end

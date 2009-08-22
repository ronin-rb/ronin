require 'ronin/ui/command_line/command'

require 'spec_helper'
require 'ui/command_line/classes/test_command'

describe UI::CommandLine::Command do
  it "should provide a version task by default" do
    UI::CommandLine::Command.tasks['version'].should_not be_nil
  end

  it "should provide a help task by default" do
    UI::CommandLine::Command.tasks['help'].should_not be_nil
  end

  it "should have a name" do
    TestCommand.new.test_name.should == 'test_command'
  end

  it "should have a default task" do
    TestCommand.start([]).should == 'default task'
  end

  it "should call the default task for missing tasks" do
    TestCommand.start(['missing']).should == 'default task'
  end

  it "should still respond to option mappings" do
    TestCommand.start(['-m']).should == 'mapped task'
  end
end

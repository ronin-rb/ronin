require 'spec_helper'
require 'ronin/ui/cli/command'

require 'ui/cli/classes/test_command'

describe UI::CLI::Command do
  subject { TestCommand }

  it "should have a command name" do
    subject.command_name.should == 'test_command'
  end

  describe "#run" do
    it "should allow running the command with options" do
      command = subject.new
      value   = 'bar'

      command.run(:foo => value)

      command.foo.should == value
    end
  end

  describe "#start" do
    subject { TestCommand.new }

    it "should parse options" do
      value = 'baz'
      subject.start(['--foo', value])

      subject.foo.should == value
    end

    it "should parse additional arguments" do
      path = 'to/file.txt'

      subject.start([path])

      subject.path.should == path
    end

    it "should parse additional arguments into an Array/Set argument" do
      value = 'bax'
      path  = 'to/file.txt'
      files = ['one.txt', 'two.txt']

      subject.start(['--foo', value, path, *files])

      subject.foo.should == value
      subject.path.should == path
      subject.files.should == files
    end
  end

  it "should have zero indentation by default" do
    command = subject.new
    command.instance_variable_get('@indent').should == 0
  end
end

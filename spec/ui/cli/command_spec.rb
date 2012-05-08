require 'spec_helper'
require 'ronin/ui/cli/command'

require 'ui/cli/classes/test_command'

describe UI::CLI::Command do
  subject { TestCommand }

  describe "command_name" do
    it "should be derived from the Class name" do
      subject.command_name.should == 'test_command'
    end
  end

  describe "usage" do
    context "without an argument" do
      it "should return the set usage" do
        subject.usage.should == '[options] PATH FILE [..]'
      end
    end

    context "with an argument" do
      let(:expected) { 'FOO' }

      subject { Class.new(described_class) }
      before  { subject.usage expected }

      it "should set the usage" do
        subject.usage.should == expected
      end
    end

    context "default" do
      subject { Class.new(described_class).usage }

      it { should == '[options]' }
    end

    context "inherited" do
      let(:superclass) { TestCommand }

      subject { Class.new(superclass).usage }

      it "should default to the usage of the superclass" do
        subject.should == superclass.usage
      end
    end
  end

  describe "summary" do
    context "without an argument" do
      it "should return the set summary" do
        subject.summary.should == 'Tests the default task'
      end
    end

    context "with an argument" do
      let(:expected) { 'Performs foo' }

      subject { Class.new(described_class) }
      before  { subject.summary expected }

      it "should set the usage" do
        subject.summary.should == expected
      end
    end

    context "default" do
      subject { Class.new(described_class).summary }

      it { should == nil }
    end

    context "inherited" do
      let(:superclass) { TestCommand }

      subject { Class.new(superclass).summary }

      it "should default to the summary of the superclass" do
        subject.should == superclass.summary
      end
    end
  end

  describe "examples" do
    context "without an argument" do
      it "should return the set summary" do
        # subject.example.should == 'Tests the default task'
      end
    end

    context "with an argument" do
      let(:expected) do
        ['--foo PATH', '--foo PATH FILE ...']
      end

      subject { Class.new(described_class) }
      before  { subject.examples expected }

      it "should set the usage" do
        subject.examples.should == expected
      end
    end

    context "default" do
      subject { Class.new(described_class).examples }

      it { should == [] }
    end

    context "inherited" do
      let(:superclass) { TestCommand }

      subject { Class.new(superclass).examples }

      it "should default to the examples of the superclass" do
        subject.should == superclass.examples
      end
    end
  end

  describe "options" do
    subject { Class.new(described_class).options }

    context "inherited" do
      it "should be {} by default" do
        subject.should == {}
      end
    end

    context described_class do
      subject { described_class.options }

      it "should have a :verbose option" do
        subject.should have_key(:verbose)
      end

      it "should have a :quiet option" do
        subject.should have_key(:quiet)
      end

      it "should have a :silent option" do
        subject.should have_key(:silent)
      end

      it "should have a :color option" do
        subject.should have_key(:color)
      end
    end
  end

  describe "option" do
    let(:name) { :foo }

    it "should define an option" do
      subject.options[name].should be_kind_of(Hash)
    end

    it "should define a parameter" do
      subject.should have_param(name)
    end
  end

  describe "each_option" do
    let(:expected) { [:verbose, :quiet, :silent, :color, :foo] }

    it "should iterate over each option" do
      names = []

      subject.each_option do |name,options|
        names << name
      end

      names.should =~ expected
    end
  end

  describe "options?" do
    it "should test if there are any defined options" do
      subject.options?.should be_true
    end
  end

  describe "arguments" do
    context "inherited" do
      subject { Class.new(described_class).arguments }

      it { should == [] }
    end
  end

  describe "argument" do
    let(:name) { :foo }

    subject { Class.new(described_class) }
    before  { subject.argument name      }

    it "should add to arguments" do
      subject.arguments.should include(name)
    end

    it "should define a parameter" do
      subject.should have_param(name)
    end
  end

  describe "each_argument" do
    let(:expected) { [:path, :files] }

    it "should iterate over each option" do
      names = []

      subject.each_argument { |name| names << name }

      names.should =~ expected
    end
  end

  describe "arguments?" do
    it "should test if there are any defined arguments" do
      subject.arguments?.should be_true
    end
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
end

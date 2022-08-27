require 'spec_helper'
require 'ronin/cli/string_methods_command'

describe Ronin::CLI::StringMethodsCommand do
  module TestStringMethodsCommand
    class TestCommand < Ronin::CLI::StringMethodsCommand
    end
  end

  let(:test_class) { TestStringMethodsCommand::TestCommand }
  subject { test_class.new }

  describe "#process_string" do
    let(:string) { 'hello world' }

    before do
      subject.method_calls << [:upcase]
      subject.method_calls << [:reverse]
    end

    it "must apply all method options to the given String" do
      expect(subject.process_string(string)).to eq("DLROW OLLEH")
    end
  end
end

require 'spec_helper'
require 'ronin/cli/method_options'
require 'ronin/cli/command'

describe Ronin::CLI::MethodOptions do
  module TestMethodOptions
    class TestCommand < Ronin::CLI::Command
      include Ronin::CLI::MethodOptions
    end
  end

  let(:test_class) { TestMethodOptions::TestCommand }
  subject { test_class.new }

  describe "#initialize" do
    it "must initialize #methods_calls to an empty Array" do
      expect(subject.method_calls).to eq([])
    end
  end

  describe "#apply_method_options" do
    let(:object) { 'hello world' }

    before do
      subject.method_calls << [:upcase]
      subject.method_calls << [:reverse]
    end

    it "must apply all method options to the given String" do
      expect(subject.apply_method_options(object)).to eq("DLROW OLLEH")
    end

    context "when #method_calls contains an entry with arguments" do
      before do
        subject.method_calls << [:slice, [0, 5]]
      end

      it "must call that method with the given arguments Array" do
        expect(subject.apply_method_options(object)).to eq("DLROW")
      end
    end

    context "when #method_calls contains a private method" do
      let(:method_name) { :puts }

      before do
        subject.method_calls << [method_name, "shouldn't print this"]
      end

      it do
        expect {
          subject.apply_method_options(object)
        }.to raise_error(ArgumentError,"cannot call method Object##{method_name} on object \"DLROW OLLEH\"")
      end
    end

    context "when #method_calls contains a method inherited from Object" do
      let(:method_name) { :instance_eval }

      before do
        subject.method_calls << [method_name, "1 + 1"]
      end

      it do
        expect {
          subject.apply_method_options(object)
        }.to raise_error(ArgumentError,"cannot call method Object##{method_name} on object \"DLROW OLLEH\"")
      end
    end
  end
end

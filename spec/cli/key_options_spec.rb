require 'spec_helper'
require 'ronin/cli/key_options'
require 'ronin/cli/command'

describe Ronin::CLI::KeyOptions do
  module TestKeyOptions
    class TestCommand < Ronin::CLI::Command
      include Ronin::CLI::KeyOptions
    end
  end

  let(:test_class) { TestKeyOptions::TestCommand }
  subject { test_class.new }

  describe ".included" do
    subject { test_class }

    it "must define a --key option" do
      expect(subject.options[:key]).to be_kind_of(CommandKit::Options::Option)
      expect(subject.options[:key].short).to eq('-k')
      expect(subject.options[:key].long).to eq('--key')
      expect(subject.options[:key].desc).to eq("The key String")
    end

    it "must define a --key-file option" do
      expect(subject.options[:key_file]).to be_kind_of(CommandKit::Options::Option)
      expect(subject.options[:key_file].short).to eq('-K')
      expect(subject.options[:key_file].long).to eq('--key-file')
      expect(subject.options[:key_file].desc).to eq("The key file")
    end
  end

  describe "options" do
    before { subject.parse_options(argv) }

    context "when the --key option is parsed" do
      let(:key)  { 'foo' }
      let(:argv) { ['--key', key] }

      it "must set #key to the given argument" do
        expect(subject.key).to eq(key)
      end
    end

    context "when the --key-file option is parsed" do
      let(:fixtures_dir) { File.join(__dir__,'fixtures') }
      let(:key_file)     { File.join(fixtures_dir,'file.txt') }

      let(:argv) { ['--key-file', key_file] }

      it "must read the key file and set #key" do
        expect(subject.key).to eq(File.binread(key_file))
      end
    end
  end
end

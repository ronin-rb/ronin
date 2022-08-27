require 'spec_helper'
require 'ronin/cli/value_processor_command'

describe Ronin::CLI::ValueProcessorCommand do
  module TestValueProcessorCommand
    class TestCommand < Ronin::CLI::ValueProcessorCommand

      def process_value(string)
        puts string.reverse
      end

    end
  end

  let(:test_class) { TestValueProcessorCommand::TestCommand }
  subject { test_class.new }

  describe "#initialize" do
    it "must initialize #files to an empty Array" do
      expect(subject.files).to eq([])
    end
  end

  describe "options" do
    describe "--file" do
      let(:file1) { 'file1.txt' }
      let(:file2) { 'file2.txt' }
      let(:argv) do
        ['--file', file1, '--file', file2]
      end
      before { subject.parse_options(argv) }

      it "must append the argument value to #files" do
        expect(subject.files).to eq([file1, file2])
      end
    end
  end

  let(:fixtures_dir) { File.join(__dir__,'fixtures') }
  let(:file)         { File.join(fixtures_dir,'file.txt') }

  describe "#run" do
    context "when arguments are given" do
      let(:args) { %w[foo bar baz] }
      let(:expected_output) do
        args.map(&:reverse).join($/) + $/
      end

      it "must process each argument and print output to stdout" do
        expect {
          subject.run(*args)
        }.to output(expected_output).to_stdout
      end
    end

    context "when --file options are given" do
      let(:argv) { ['--file', file] }
      let(:expected_output) do
        File.readlines(file, chomp: true).map(&:reverse).join($/) + $/
      end

      before { subject.parse_options(argv) }

      it "must read and process each --file argument and print output to stdout" do
        expect {
          subject.run()
        }.to output(expected_output).to_stdout
      end
    end

    context "when --file options and arguments are given" do
      let(:argv) { ['--file', file] }
      let(:args) { %w[abc def ghi] }

      let(:expected_values) { File.readlines(file, chomp: true) + args }
      let(:expected_output) do
        expected_values.map(&:reverse).join($/) + $/
      end

      before { subject.parse_options(argv) }

      it "must read and process the --file arguments then the arguments" do
        expect {
          subject.run(*args)
        }.to output(expected_output).to_stdout
      end
    end

    context "when neither --file options nor arguments are given" do
      it "must print an error message to stderr and exit with 1" do
        expect(subject).to receive(:print_error).with(
          "must specify one or more arguments, or the --file option"
        )

        expect {
          subject.run()
        }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(1)
        end
      end
    end
  end

  describe "#process_file" do
    let(:expected_output) do
      File.readlines(file, chomp: true).map(&:reverse).join($/) + $/
    end

    it "must read and process each line of the file and print them to stdout" do
      expect {
        subject.process_file(file)
      }.to output(expected_output).to_stdout
    end
  end

  describe "#process_value" do
    subject { described_class.new }

    let(:value) { "foo" }

    it do
      expect {
        subject.process_value(value)
      }.to raise_error(NotImplementedError,"#{subject.class}#process_value method was not implemented")
    end
  end
end

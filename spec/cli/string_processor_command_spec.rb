require 'spec_helper'
require 'ronin/cli/string_processor_command'

describe Ronin::CLI::StringProcessorCommand do
  module TestStringProcessorCommand
    class TestCommand < Ronin::CLI::StringProcessorCommand

      def process_string(string)
        string.reverse
      end

    end
  end

  let(:test_class) { TestStringProcessorCommand::TestCommand }
  subject { test_class.new }

  describe described_class::StringValue do
    let(:string) { "foo" }

    subject { described_class.new(string) }

    describe "#initialize" do
      it "must set #string" do
        expect(subject.string).to eq(string)
      end
    end
  end

  describe described_class::FileValue do
    let(:file) { "file.txt" }

    subject { described_class.new(file) }

    describe "#initialize" do
      it "must set #file" do
        expect(subject.file).to eq(file)
      end
    end
  end

  describe "#initialize" do
    it "must initialize #input_values to an empty Array" do
      expect(subject.input_values).to eq([])
    end
  end

  describe "options" do
    describe "--string" do
      let(:string1) { "foo" }
      let(:string2) { "bar" }
      let(:argv)    { ['--string', string1, '--string', string2] }

      before { subject.parse_options(argv) }

      it "must append a #{described_class}::StringValue to #input_values" do
        expect(subject.input_values.length).to eq(2)

        expect(subject.input_values[0]).to be_kind_of(described_class::StringValue)
        expect(subject.input_values[0].string).to eq(string1)

        expect(subject.input_values[1]).to be_kind_of(described_class::StringValue)
        expect(subject.input_values[1].string).to eq(string2)
      end
    end

    describe "--file" do
      let(:file1) { "foo" }
      let(:file2) { "bar" }
      let(:argv)  { ['--file', file1, '--file', file2] }

      before { subject.parse_options(argv) }

      it "must append a #{described_class}::FileValue to #input_values" do
        expect(subject.input_values.length).to eq(2)

        expect(subject.input_values[0]).to be_kind_of(described_class::FileValue)
        expect(subject.input_values[0].file).to eq(file1)

        expect(subject.input_values[1]).to be_kind_of(described_class::FileValue)
        expect(subject.input_values[1].file).to eq(file2)
      end
    end
  end

  let(:fixtures_dir) { File.join(__dir__,'fixtures') }
  let(:file)         { File.join(fixtures_dir,'file.txt') }
  let(:file2)        { File.join(fixtures_dir,'file2.txt') }

  describe "#run" do
    context "when arguments are given" do
      let(:args) { [file, file2] }

      let(:expected_values) { [File.read(file), File.read(file2)] }
      let(:expected_output) do
        expected_values.map(&:reverse).join($/) + $/
      end

      it "must read and process each argument as a file in full" do
        expect {
          subject.run(*args)
        }.to output(expected_output).to_stdout
      end

      context "and when --file or --string options are given" do
        let(:string) { "abc" }
        let(:argv)   { ['--string', string, '--file', file] }

        before { subject.parse_options(argv) }

        let(:expected_values) do
          [string, File.read(file)] + args.map { |path| File.read(path) }
        end
        let(:expected_output) do
          expected_values.map(&:reverse).join($/) + $/
        end

        it "must process the input from the --file and --string options then read and process the arguments" do
          expect {
            subject.run(*args)
          }.to output(expected_output).to_stdout
        end
      end
    end

    context "when no arguments are given" do
      context "but --file or --string options are given" do
        let(:string) { "abc" }
        let(:argv)   { ['--string', string, '--file', file] }

        before { subject.parse_options(argv) }

        let(:expected_values) { [string, File.read(file)] }
        let(:expected_output) do
          expected_values.map(&:reverse).join($/) + $/
        end

        it "must process the input from the --file and --string options in the order given" do
          expect {
            subject.run()
          }.to output(expected_output).to_stdout
        end
      end

      context "and no options were given" do
        let(:expected_output) { File.read(file).reverse + $/ }

        let(:stdin) { File.open(file) }
        subject { test_class.new(stdin: stdin) }

        it "must read and process input from stdin in full" do
          expect {
            subject.run()
          }.to output(expected_output).to_stdout
        end
      end
    end
  end

  describe "#open_file" do
    let(:path) { __FILE__ }

    context "when given a block" do
      it "must yield the newly opened File" do
        expect { |b|
          subject.open_file(path,&b)
        }.to yield_with_args(File)
      end

      it "must open the file in non-binary mode by default" do
        file_binmode = nil

        subject.open_file(path) do |file|
          file_binmode = file.binmode?
        end

        expect(file_binmode).to be(false)
      end
    end

    context "when no block is given" do
      it "must return the opened File" do
        file = subject.open_file(path)

        expect(file).to be_kind_of(File)
        expect(file.path).to eq(path)
      end

      it "must open the file in non-binary mode by default" do
        file = subject.open_file(path)

        expect(file.binmode?).to be(false)
      end
    end
  end

  describe "#process_input" do
    let(:input) { File.open(file) }
    let(:expected_output) { File.read(file).reverse + $/ }

    it "must read the input stream and process the full String" do
      expect {
        subject.process_input(input)
      }.to output(expected_output).to_stdout
    end

    context "when the --multiline option is given" do
      let(:argv) { %w[--multiline] }
      let(:expected_output) do
        File.readlines(file, chomp: true).map(&:reverse).join($/) + $/
      end

      before { subject.parse_options(argv) }

      it "must read and process each line of the input" do
        expect {
          subject.process_input(input)
        }.to output(expected_output).to_stdout
      end

      context "and the --keep-newlines option is given" do
        let(:argv) { %w[--multiline --keep-newlines] }

        let(:expected_output) do
          File.readlines(file).map(&:reverse).join($/) + $/
        end

        it "must not omit the newline character at the end of each line" do
          expect {
            subject.process_input(input)
          }.to output(expected_output).to_stdout
        end
      end
    end
  end

  describe "#process_string" do
    subject { described_class.new }

    let(:string) { "foo" }

    it do
      expect {
        subject.process_string(string)
      }.to raise_error(NotImplementedError,"#{subject.class}#process_string method was not implemented")
    end
  end

  describe "#print_string" do
    let(:string) { "hello world" }

    it "must print the string using #puts" do
      expect(subject).to receive(:puts).with(string)

      subject.print_string(string)
    end
  end
end

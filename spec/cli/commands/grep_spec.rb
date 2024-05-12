require 'spec_helper'
require 'ronin/cli/commands/grep'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Grep do
  include_examples "man_page"

  let(:red)             { CommandKit::Colors::ANSI::RED }
  let(:green)           { CommandKit::Colors::ANSI::GREEN }
  let(:magenta)         { CommandKit::Colors::ANSI::MAGENTA }
  let(:cyan)            { CommandKit::Colors::ANSI::CYAN }
  let(:bold)            { CommandKit::Colors::ANSI::BOLD }
  let(:reset_color)     { CommandKit::Colors::ANSI::RESET_COLOR }
  let(:reset_intensity) { CommandKit::Colors::ANSI::RESET_INTENSITY }
  let(:reset)           { reset_color + reset_intensity }

  describe "#print_line_prefix" do
    let(:filename)    { 'foo.txt' }
    let(:line_number) { 123 }

    let(:stdout) { StringIO.new }

    subject { described_class.new(stdout: stdout) }
    before { allow(stdout).to receive(:tty?).and_return(true) }

    it "must not print anything by default" do
      subject.print_line_prefix(filename: filename, line_number: line_number)

      expect(stdout.string).to be_empty
    end

    context "when the --with-filename option is given" do
      before { subject.options[:with_filename] = true }

      it "must print the filename in magenta followed by a ':' in cyan" do
        subject.print_line_prefix(filename: filename, line_number: line_number)

        expect(stdout.string).to eq(
          "#{magenta}#{filename}#{reset_color}#{cyan}:#{reset_color}"
        )
      end
    end

    context "when the --line-numbers option is given" do
      before { subject.options[:line_numbers] = true }

      it "must print the line number in green followed by a ':' in cyan" do
        subject.print_line_prefix(filename: filename, line_number: line_number)

        expect(stdout.string).to eq(
          "#{green}#{line_number}#{reset_color}#{cyan}:#{reset_color}"
        )
      end
    end

    context "when the --with-filename and the --line-numbers options are given" do
      before do
        subject.options[:with_filename] = true
        subject.options[:line_numbers]  = true
      end

      it "must print the filename in magenta followed by a ':' in cyan, and the line number in green followed by a ':' in cyan" do
        subject.print_line_prefix(filename: filename, line_number: line_number)

        expect(stdout.string).to eq(
          "#{magenta}#{filename}#{reset_color}#{cyan}:#{reset_color}" +
          "#{green}#{line_number}#{reset_color}#{cyan}:#{reset_color}"
        )
      end
    end

    context "when the --line-numbers option is given" do
      before { subject.options[:line_numbers] = true }

      it "must print the line number in green followed by a ':' in cyan" do
        subject.print_line_prefix(filename: filename, line_number: line_number)

        expect(stdout.string).to eq(
          "#{green}#{line_number}#{reset_color}#{cyan}:#{reset_color}"
        )
      end
    end
  end

  describe "#print_match" do
    let(:text)    { "The quick brown fox jumps over the lazy dog" }
    let(:pattern) { "jumps" }
    let(:match)   { text.match(pattern) }

    let(:stdout) { StringIO.new }

    subject { described_class.new(stdout: stdout) }
    before { allow(stdout).to receive(:tty?).and_return(true) }

    it "must print the matched text as bold red" do
      subject.print_match(match)

      expect(stdout.string).to eq(
        "#{bold}#{red}#{match[0]}#{reset_color}#{reset_intensity}"
      )
    end

    context "when the --only-matching option is given" do
      before { subject.options[:only_matching] = true }

      it "must print the matched text as bold red on it's own line" do
        subject.print_match(match)

        expect(stdout.string).to eq(
          "#{bold}#{red}#{match[0]}#{reset_color}#{reset_intensity}#{$/}"
        )
      end
    end
  end
end

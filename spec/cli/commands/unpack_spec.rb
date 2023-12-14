require 'spec_helper'
require 'ronin/cli/commands/unpack'
require_relative 'man_page_example'

require 'tempfile'

describe Ronin::CLI::Commands::Unpack do
  include_examples "man_page"

  describe "#run" do
    let(:values) do
      ['A', -1, 42, 1.5, "abc", [1,2,4,8]]
    end
    let(:data)  { values.flatten.pack('ZlLFZ*L4') }
    let(:types) { %w[char int32 uint32 float string int32[4]] }
    let(:pretty_print) { values.inspect }

    context "when the --string option is given" do
      before { subject.options[:string] = data }

      it "must unpack the --string value using the TYPE arguments" do
        expect {
          subject.run(*types)
        }.to output("#{pretty_print}#{$/}").to_stdout
      end
    end

    context "when the --file option is given" do
      let(:tempfile) { Tempfile.new(['ronin-unpack','.bin']) }
      let(:path)     { tempfile.path }

      before do
        tempfile.write(data)
        tempfile.flush
      end
      before { subject.options[:file] = path }

      it "must read the file and unpack the binary data using the TYPE arguments" do
        expect {
          subject.run(*types)
        }.to output("#{pretty_print}#{$/}").to_stdout
      end
    end

    context "when neither --string nor --file options are given" do
      let(:stdin) { StringIO.new(data) }

      subject { described_class.new(stdin: stdin) }

      it "must read from stdin and unpack the binary data" do
        expect {
          subject.run(*types)
        }.to output("#{pretty_print}#{$/}").to_stdout
      end
    end
  end
end

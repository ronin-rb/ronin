require 'spec_helper'
require 'ronin/cli/commands/unarchive'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Unarchive do
  include_examples "man_page"

  describe "#format_for" do
    context "when given a file path ending in '.tar'" do
      it "must return :tar" do
        expect(subject.format_for('path/to/arch.tar')).to eq(:tar)
      end
    end

    context "when given a file path ending in '.zip'" do
      it "must return :zip" do
        expect(subject.format_for('path/to/arch.zip')).to eq(:zip)
      end
    end

    context "when given a file path with an unknown extension" do
      it "must return nil" do
        expect(subject.format_for('path/to/arch.dat')).to be(nil)
      end

      context "but options[:format] is set" do
        let(:format) { :zip }

        before { subject.options[:format] = format }

        it "must return the options[:format] value" do
          expect(subject.format_for('path/to/arch.dat')).to eq(format)
        end
      end
    end
  end
end

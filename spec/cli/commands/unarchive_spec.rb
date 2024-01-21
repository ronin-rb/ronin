require 'spec_helper'
require 'ronin/cli/commands/unarchive'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Unarchive do
  include_examples "man_page"

  let(:fixtures_dir) { File.join(__dir__,'fixtures') }

  let(:tar_archive)     { File.join(fixtures_dir,'arch.tar') }
  let(:zip_archive)     { File.join(fixtures_dir,'arch.zip') }
  let(:unknown_archive) { File.join(fixtures_dir,'arch') }

  describe "#format_for" do
    context "when given a file path ending in '.tar'" do
      it "must return :tar" do
        expect(subject.format_for(tar_archive)).to eq(:tar)
      end
    end

    context "when given a file path ending in '.zip'" do
      it "must return :zip" do
        expect(subject.format_for(zip_archive)).to eq(:zip)
      end
    end

    context "when given a file path with an unknown extension" do
      it "must return nil" do
        expect(subject.format_for(unknown_archive)).to be(nil)
      end

      context "but options[:format] is set" do
        let(:format) { :zip }

        before { subject.options[:format] = format }

        it "must return the options[:format] value" do
          expect(subject.format_for(unknown_archive)).to eq(format)
        end
      end
    end
  end

  describe "#open_archive" do
    context "when given a '.tar' archive" do
      it "must yield a Ronin::Support::Archive::Tar::Reader object" do
        expect { |b|
          subject.open_archive(tar_archive,&b)
        }.to yield_with_args(Ronin::Support::Archive::Tar::Reader)
      end
    end

    context "when given a '.zip' archive" do
      it "must yield a Ronin::Support::Archive::Zip::Reader object" do
        expect { |b|
          subject.open_archive(zip_archive,&b)
        }.to yield_with_args(Ronin::Support::Archive::Zip::Reader)
      end
    end

    context "when given an archive with an unknown extension" do
      it "must print an error and yield nothing" do
        expect(subject).to receive(:print_error).with("unknown archive format: #{unknown_archive}")

        expect { |b|
          subject.open_archive(unknown_archive,&b)
        }.to_not yield_control
      end
    end
  end
end

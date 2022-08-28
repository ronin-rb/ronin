require 'spec_helper'
require 'ronin/cli/commands/unquote'

describe Ronin::CLI::Commands::Unquote do
  describe "options" do
    before { subject.parse_options(argv) }

    describe "--c" do
      let(:argv) { %w[--c] }

      it "must require 'ronin/support/encoding/c'" do
        expect(require 'ronin/support/encoding/c').to be(false)
      end

      it "must add :c_unquote to #method_calls" do
        expect(subject.method_calls.last).to eq(:c_unquote)
      end
    end

    describe "--hex" do
      let(:argv) { %w[--hex] }

      it "must require 'ronin/support/encoding/hex'" do
        expect(require 'ronin/support/encoding/hex').to be(false)
      end

      it "must add :hex_unquote to #method_calls" do
        expect(subject.method_calls.last).to eq(:hex_unquote)
      end
    end

    describe "--js" do
      let(:argv) { %w[--js] }

      it "must require 'ronin/support/encoding/js'" do
        expect(require 'ronin/support/encoding/js').to be(false)
      end

      it "must add :js_unquote to #method_calls" do
        expect(subject.method_calls.last).to eq(:js_unquote)
      end
    end

    describe "--shell" do
      let(:argv) { %w[--shell] }

      it "must require 'ronin/support/encoding/shell'" do
        expect(require 'ronin/support/encoding/shell').to be(false)
      end

      it "must add :shell_unquote to #method_calls" do
        expect(subject.method_calls.last).to eq(:shell_unquote)
      end
    end

    describe "--powershell" do
      let(:argv) { %w[--powershell] }

      it "must require 'ronin/support/encoding/powershell'" do
        expect(require 'ronin/support/encoding/powershell').to be(false)
      end

      it "must add :powershell_unquote to #method_calls" do
        expect(subject.method_calls.last).to eq(:powershell_unquote)
      end
    end

    describe "--ruby" do
      let(:argv) { %w[--ruby] }

      it "must require 'ronin/support/encoding/ruby'" do
        expect(require 'ronin/support/encoding/ruby').to be(false)
      end

      it "must add :ruby_unquote to #method_calls" do
        expect(subject.method_calls.last).to eq(:ruby_unquote)
      end
    end
  end
end

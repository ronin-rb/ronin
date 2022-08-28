require 'spec_helper'
require 'ronin/cli/commands/escape'

describe Ronin::CLI::Commands::Escape do
  describe "options" do
    before { subject.parse_options(argv) }

    describe "--c" do
      let(:argv) { %w[--c] }

      it "must require 'ronin/support/encoding/c'" do
        expect(require 'ronin/support/encoding/c').to be(false)
      end

      it "must add :c_escape to #method_calls" do
        expect(subject.method_calls.last).to eq(:c_escape)
      end
    end

    describe "--hex" do
      let(:argv) { %w[--hex] }

      it "must require 'ronin/support/encoding/hex'" do
        expect(require 'ronin/support/encoding/hex').to be(false)
      end

      it "must add :hex_escape to #method_calls" do
        expect(subject.method_calls.last).to eq(:hex_escape)
      end
    end

    describe "--html" do
      let(:argv) { %w[--html] }

      it "must require 'ronin/support/encoding/html'" do
        expect(require 'ronin/support/encoding/html').to be(false)
      end

      it "must add :html_escape to #method_calls" do
        expect(subject.method_calls.last).to eq(:html_escape)
      end
    end

    describe "--uri" do
      let(:argv) { %w[--uri] }

      it "must require 'ronin/support/encoding/uri'" do
        expect(require 'ronin/support/encoding/uri').to be(false)
      end

      it "must add :uri_escape to #method_calls" do
        expect(subject.method_calls.last).to eq(:uri_escape)
      end
    end

    describe "--http" do
      let(:argv) { %w[--http] }

      it "must require 'ronin/support/encoding/http'" do
        expect(require 'ronin/support/encoding/http').to be(false)
      end

      it "must add :http_escape to #method_calls" do
        expect(subject.method_calls.last).to eq(:http_escape)
      end
    end

    describe "--js" do
      let(:argv) { %w[--js] }

      it "must require 'ronin/support/encoding/js'" do
        expect(require 'ronin/support/encoding/js').to be(false)
      end

      it "must add :js_escape to #method_calls" do
        expect(subject.method_calls.last).to eq(:js_escape)
      end
    end

    describe "--shell" do
      let(:argv) { %w[--shell] }

      it "must require 'ronin/support/encoding/shell'" do
        expect(require 'ronin/support/encoding/shell').to be(false)
      end

      it "must add :shell_escape to #method_calls" do
        expect(subject.method_calls.last).to eq(:shell_escape)
      end
    end

    describe "--powershell" do
      let(:argv) { %w[--powershell] }

      it "must require 'ronin/support/encoding/powershell'" do
        expect(require 'ronin/support/encoding/powershell').to be(false)
      end

      it "must add :powershell_escape to #method_calls" do
        expect(subject.method_calls.last).to eq(:powershell_escape)
      end
    end

    describe "--xml" do
      let(:argv) { %w[--xml] }

      it "must require 'ronin/support/encoding/xml'" do
        expect(require 'ronin/support/encoding/xml').to be(false)
      end

      it "must add :xml_escape to #method_calls" do
        expect(subject.method_calls.last).to eq(:xml_escape)
      end
    end

    describe "--string" do
      let(:argv) { %w[--string] }

      it "must require 'ronin/support/encoding/core_ext/string'" do
        expect(require 'ronin/support/encoding/core_ext/string').to be(false)
      end

      it "must add :escape to #method_calls" do
        expect(subject.method_calls.last).to eq(:escape)
      end
    end
  end
end

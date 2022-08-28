require 'spec_helper'
require 'ronin/cli/commands/encode'

describe Ronin::CLI::Commands::Encode do
  describe "options" do
    before { subject.parse_options(argv) }

    describe "--base32" do
      let(:argv) { %w[--base32] }

      it "must require 'ronin/support/encoding/base32'" do
        expect(require 'ronin/support/encoding/base32').to be(false)
      end

      it "must add :base32_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:base32_encode)
      end
    end

    describe "--base64" do
      let(:argv) { %w[--base64] }

      it "must require 'ronin/support/encoding/base64'" do
        expect(require 'ronin/support/encoding/base64').to be(false)
      end

      it "must add :base64_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:base64_encode)
      end
    end

    describe "--c" do
      let(:argv) { %w[--c] }

      it "must require 'ronin/support/encoding/c'" do
        expect(require 'ronin/support/encoding/c').to be(false)
      end

      it "must add :c_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:c_encode)
      end
    end

    describe "--hex" do
      let(:argv) { %w[--hex] }

      it "must require 'ronin/support/encoding/hex'" do
        expect(require 'ronin/support/encoding/hex').to be(false)
      end

      it "must add :hex_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:hex_encode)
      end
    end

    describe "--html" do
      let(:argv) { %w[--html] }

      it "must require 'ronin/support/encoding/html'" do
        expect(require 'ronin/support/encoding/html').to be(false)
      end

      it "must add :html_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:html_encode)
      end
    end

    describe "--uri" do
      let(:argv) { %w[--uri] }

      it "must require 'ronin/support/encoding/uri'" do
        expect(require 'ronin/support/encoding/uri').to be(false)
      end

      it "must add :uri_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:uri_encode)
      end
    end

    describe "--http" do
      let(:argv) { %w[--http] }

      it "must require 'ronin/support/encoding/http'" do
        expect(require 'ronin/support/encoding/http').to be(false)
      end

      it "must add :http_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:http_encode)
      end
    end

    describe "--js" do
      let(:argv) { %w[--js] }

      it "must require 'ronin/support/encoding/js'" do
        expect(require 'ronin/support/encoding/js').to be(false)
      end

      it "must add :js_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:js_encode)
      end
    end

    describe "--shell" do
      let(:argv) { %w[--shell] }

      it "must require 'ronin/support/encoding/shell'" do
        expect(require 'ronin/support/encoding/shell').to be(false)
      end

      it "must add :shell_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:shell_encode)
      end
    end

    describe "--powershell" do
      let(:argv) { %w[--powershell] }

      it "must require 'ronin/support/encoding/powershell'" do
        expect(require 'ronin/support/encoding/powershell').to be(false)
      end

      it "must add :powershell_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:powershell_encode)
      end
    end

    describe "--xml" do
      let(:argv) { %w[--xml] }

      it "must require 'ronin/support/encoding/xml'" do
        expect(require 'ronin/support/encoding/xml').to be(false)
      end

      it "must add :xml_encode to #method_calls" do
        expect(subject.method_calls.last).to eq(:xml_encode)
      end
    end
  end
end

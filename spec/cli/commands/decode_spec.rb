require 'spec_helper'
require 'ronin/cli/commands/decode'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Decode do
  include_examples "man_page"

  describe "options" do
    before { subject.parse_options(argv) }

    describe "--base32" do
      let(:argv) { %w[--base32] }

      it "must require 'ronin/support/encoding/base32'" do
        expect(require('ronin/support/encoding/base32')).to be(false)
      end

      it "must add :base32_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:base32_decode)
      end
    end

    describe "--base64" do
      let(:argv) { %w[--base64] }

      it "must require 'ronin/support/encoding/base64'" do
        expect(require('ronin/support/encoding/base64')).to be(false)
      end

      it "must add :base64_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:base64_decode)
      end
    end

    describe "--base64=strict" do
      let(:argv) { %w[--base64=strict] }

      it "must require 'ronin/support/encoding/base64'" do
        expect(require('ronin/support/encoding/base64')).to be(false)
      end

      it "must add [:base64_encode, [], {mode: :strict}] to #method_calls" do
        expect(subject.method_calls.last).to eq(
          [:base64_decode, [], {mode: :strict}]
        )
      end
    end

    describe "--base64=url" do
      let(:argv) { %w[--base64=url] }

      it "must require 'ronin/support/encoding/base64'" do
        expect(require('ronin/support/encoding/base64')).to be(false)
      end

      it "must add [:base64_encode, [], {mode: :url_safe}] to #method_calls" do
        expect(subject.method_calls.last).to eq(
          [:base64_decode, [], {mode: :url_safe}]
        )
      end
    end

    describe "--c" do
      let(:argv) { %w[--c] }

      it "must require 'ronin/support/encoding/c'" do
        expect(require('ronin/support/encoding/c')).to be(false)
      end

      it "must add :c_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:c_decode)
      end
    end

    describe "--hex" do
      let(:argv) { %w[--hex] }

      it "must require 'ronin/support/encoding/hex'" do
        expect(require('ronin/support/encoding/hex')).to be(false)
      end

      it "must add :hex_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:hex_decode)
      end
    end

    describe "--html" do
      let(:argv) { %w[--html] }

      it "must require 'ronin/support/encoding/html'" do
        expect(require('ronin/support/encoding/html')).to be(false)
      end

      it "must add :html_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:html_decode)
      end
    end

    describe "--uri" do
      let(:argv) { %w[--uri] }

      it "must require 'ronin/support/encoding/uri'" do
        expect(require('ronin/support/encoding/uri')).to be(false)
      end

      it "must add :uri_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:uri_decode)
      end
    end

    describe "--http" do
      let(:argv) { %w[--http] }

      it "must require 'ronin/support/encoding/http'" do
        expect(require('ronin/support/encoding/http')).to be(false)
      end

      it "must add :http_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:http_decode)
      end
    end

    describe "--js" do
      let(:argv) { %w[--js] }

      it "must require 'ronin/support/encoding/js'" do
        expect(require('ronin/support/encoding/js')).to be(false)
      end

      it "must add :js_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:js_decode)
      end
    end

    describe "--shell" do
      let(:argv) { %w[--shell] }

      it "must require 'ronin/support/encoding/shell'" do
        expect(require('ronin/support/encoding/shell')).to be(false)
      end

      it "must add :shell_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:shell_decode)
      end
    end

    describe "--powershell" do
      let(:argv) { %w[--powershell] }

      it "must require 'ronin/support/encoding/powershell'" do
        expect(require('ronin/support/encoding/powershell')).to be(false)
      end

      it "must add :powershell_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:powershell_decode)
      end
    end

    describe "--punycode" do
      let(:argv) { %w[--punycode] }

      it "must require 'ronin/support/encoding/punycode'" do
        expect(require('ronin/support/encoding/punycode')).to be(false)
      end

      it "must add :punycode_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:punycode_decode)
      end
    end

    describe "--quoted-printable" do
      let(:argv) { %w[--quoted-printable] }

      it "must require 'ronin/support/encoding/quoted_printable'" do
        expect(require('ronin/support/encoding/quoted_printable')).to be(false)
      end

      it "must add :quoted_printable_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:quoted_printable_decode)
      end
    end

    describe "--php" do
      let(:argv) { %w[--php] }

      it "must require 'ronin/support/encoding/php'" do
        expect(require('ronin/support/encoding/php')).to be(false)
      end

      it "must add :php_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:php_decode)
      end
    end

    describe "--ruby" do
      let(:argv) { %w[--ruby] }

      it "must require 'ronin/support/encoding/ruby'" do
        expect(require('ronin/support/encoding/ruby')).to be(false)
      end

      it "must add :ruby_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:ruby_decode)
      end
    end

    describe "--xml" do
      let(:argv) { %w[--xml] }

      it "must require 'ronin/support/encoding/xml'" do
        expect(require('ronin/support/encoding/xml')).to be(false)
      end

      it "must add :xml_decode to #method_calls" do
        expect(subject.method_calls.last).to eq(:xml_decode)
      end
    end
  end
end

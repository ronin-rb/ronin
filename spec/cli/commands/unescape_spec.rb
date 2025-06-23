require 'spec_helper'
require 'ronin/cli/commands/unescape'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Unescape do
  include_examples "man_page"

  describe "options" do
    before { subject.parse_options(argv) }

    describe "--c" do
      let(:argv) { %w[--c] }

      it "must require 'ronin/support/encoding/c'" do
        expect(require('ronin/support/encoding/c')).to be(false)
      end

      it "must add :c_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:c_unescape)
      end
    end

    describe "--hex" do
      let(:argv) { %w[--hex] }

      it "must require 'ronin/support/encoding/hex'" do
        expect(require('ronin/support/encoding/hex')).to be(false)
      end

      it "must add :hex_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:hex_unescape)
      end
    end

    describe "--html" do
      let(:argv) { %w[--html] }

      it "must require 'ronin/support/encoding/html'" do
        expect(require('ronin/support/encoding/html')).to be(false)
      end

      it "must add :html_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:html_unescape)
      end
    end

    describe "--uri" do
      let(:argv) { %w[--uri] }

      it "must require 'ronin/support/encoding/uri'" do
        expect(require('ronin/support/encoding/uri')).to be(false)
      end

      it "must add :uri_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:uri_unescape)
      end
    end

    describe "--http" do
      let(:argv) { %w[--http] }

      it "must require 'ronin/support/encoding/http'" do
        expect(require('ronin/support/encoding/http')).to be(false)
      end

      it "must add :http_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:http_unescape)
      end
    end

    describe "--js" do
      let(:argv) { %w[--js] }

      it "must require 'ronin/support/encoding/js'" do
        expect(require('ronin/support/encoding/js')).to be(false)
      end

      it "must add :js_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:js_unescape)
      end
    end

    describe "--nodejs" do
      let(:argv) { %w[--nodejs] }

      it "must require 'ronin/support/encoding/node_js'" do
        expect(require('ronin/support/encoding/node_js')).to be(false)
      end

      it "must add :node_js_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:node_js_unescape)
      end
    end

    describe "--shell" do
      let(:argv) { %w[--shell] }

      it "must require 'ronin/support/encoding/shell'" do
        expect(require('ronin/support/encoding/shell')).to be(false)
      end

      it "must add :shell_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:shell_unescape)
      end
    end

    describe "--powershell" do
      let(:argv) { %w[--powershell] }

      it "must require 'ronin/support/encoding/powershell'" do
        expect(require('ronin/support/encoding/powershell')).to be(false)
      end

      it "must add :powershell_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:powershell_unescape)
      end
    end

    describe "--quoted-printable" do
      let(:argv) { %w[--quoted-printable] }

      it "must require 'ronin/support/encoding/quoted_printable'" do
        expect(require('ronin/support/encoding/quoted_printable')).to be(false)
      end

      it "must add :quoted_printable_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:quoted_printable_unescape)
      end
    end

    describe "--xml" do
      let(:argv) { %w[--xml] }

      it "must require 'ronin/support/encoding/xml'" do
        expect(require('ronin/support/encoding/xml')).to be(false)
      end

      it "must add :xml_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:xml_unescape)
      end
    end

    describe "--php" do
      let(:argv) { %w[--php] }

      it "must require 'ronin/support/encoding/php'" do
        expect(require('ronin/support/encoding/php')).to be(false)
      end

      it "must add :php_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:php_unescape)
      end
    end

    describe "--ruby" do
      let(:argv) { %w[--ruby] }

      it "must require 'ronin/support/encoding/ruby'" do
        expect(require('ronin/support/encoding/ruby')).to be(false)
      end

      it "must add :ruby_unescape to #method_calls" do
        expect(subject.method_calls.last).to eq(:ruby_unescape)
      end
    end
  end
end

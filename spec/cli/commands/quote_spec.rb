require 'spec_helper'
require 'ronin/cli/commands/quote'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Quote do
  include_examples "man_page"

  describe "options" do
    before { subject.parse_options(argv) }

    describe "--c" do
      let(:argv) { %w[--c] }

      it "must require 'ronin/support/encoding/c'" do
        expect(require('ronin/support/encoding/c')).to be(false)
      end

      it "must add :c_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:c_string)
      end
    end

    describe "--hex" do
      let(:argv) { %w[--hex] }

      it "must require 'ronin/support/encoding/hex'" do
        expect(require('ronin/support/encoding/hex')).to be(false)
      end

      it "must add :hex_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:hex_string)
      end
    end

    describe "--java" do
      let(:argv) { %w[--java] }

      it "must require 'ronin/support/encoding/java'" do
        expect(require('ronin/support/encoding/java')).to be(false)
      end

      it "must add :java_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:java_string)
      end
    end

    describe "--js" do
      let(:argv) { %w[--js] }

      it "must require 'ronin/support/encoding/js'" do
        expect(require('ronin/support/encoding/js')).to be(false)
      end

      it "must add :js_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:js_string)
      end
    end

    describe "--nodejs" do
      let(:argv) { %w[--nodejs] }

      it "must require 'ronin/support/encoding/node_js'" do
        expect(require('ronin/support/encoding/node_js')).to be(false)
      end

      it "must add :node_js_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:node_js_string)
      end
    end

    describe "--shell" do
      let(:argv) { %w[--shell] }

      it "must require 'ronin/support/encoding/shell'" do
        expect(require('ronin/support/encoding/shell')).to be(false)
      end

      it "must add :shell_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:shell_string)
      end
    end

    describe "--powershell" do
      let(:argv) { %w[--powershell] }

      it "must require 'ronin/support/encoding/powershell'" do
        expect(require('ronin/support/encoding/powershell')).to be(false)
      end

      it "must add :powershell_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:powershell_string)
      end
    end

    describe "--perl" do
      let(:argv) { %w[--perl] }

      it "must require 'ronin/support/encoding/perl'" do
        expect(require('ronin/support/encoding/perl')).to be(false)
      end

      it "must add :perl_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:perl_string)
      end
    end

    describe "--php" do
      let(:argv) { %w[--php] }

      it "must require 'ronin/support/encoding/php'" do
        expect(require('ronin/support/encoding/php')).to be(false)
      end

      it "must add :php_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:php_string)
      end
    end

    describe "--python" do
      let(:argv) { %w[--python] }

      it "must require 'ronin/support/encoding/python'" do
        expect(require('ronin/support/encoding/python')).to be(false)
      end

      it "must add :python_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:python_string)
      end
    end

    describe "--ruby" do
      let(:argv) { %w[--ruby] }

      it "must require 'ronin/support/encoding/ruby'" do
        expect(require('ronin/support/encoding/ruby')).to be(false)
      end

      it "must add :ruby_string to #method_calls" do
        expect(subject.method_calls.last).to eq(:ruby_string)
      end
    end
  end
end

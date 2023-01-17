require 'spec_helper'
require 'ronin/cli/printing/syntax_highlighting'
require 'ronin/cli/command'

require 'rouge/lexers/html'

describe Ronin::CLI::Printing::SyntaxHighlighting do
  module TestPrintingSyntaxHighlighting
    class TestCommand < Ronin::CLI::Command
      include Ronin::CLI::Printing::SyntaxHighlighting
    end
  end

  let(:test_command) { TestPrintingSyntaxHighlighting::TestCommand }
  subject { test_command.new }

  describe "#initialize" do
  end

  describe "#syntax_lexer_for" do
    context "when given the filename: keyword argument" do
      it "must return the Rouge::Lexer for the filename extension" do
        expect(subject.syntax_lexer_for(filename: 'foo.html')).to be(
          Rouge::Lexers::HTML
        )
      end

      context "when given nil" do
        it "must return Rouge::Lexers::PlainText" do
          expect(subject.syntax_lexer_for(filename: nil)).to be(
            Rouge::Lexers::PlainText
          )
        end
      end
    end

    context "when given the mimetype: keyword argument" do
      it "must return the Rouge::Lexer for the given MIME type" do
        expect(subject.syntax_lexer_for(mimetype: 'text/html')).to be(
          Rouge::Lexers::HTML
        )
      end

      context "when given nil" do
        it "must return Rouge::Lexers::PlainText" do
          expect(subject.syntax_lexer_for(mimetype: nil)).to be(
            Rouge::Lexers::PlainText
          )
        end
      end
    end

    context "when given the source: keyword argument" do
      it "must return the Rouge::Lexer for the given source" do
        expect(subject.syntax_lexer_for(source: '<html></html>')).to be(
          Rouge::Lexers::HTML
        )
      end

      context "when given nil" do
        it "must return Rouge::Lexers::PlainText" do
          expect(subject.syntax_lexer_for(source: nil)).to be(
            Rouge::Lexers::PlainText
          )
        end
      end
    end
  end

  describe "#syntax_lexer" do
    it "must return the Rouge::Lexer for the given name" do
      expect(subject.syntax_lexer('html')).to be(
        Rouge::Lexers::HTML
      )
    end

    context "when given nil" do
      it "must return nil" do
        expect(subject.syntax_lexer(nil)).to be(nil)
      end
    end
  end

  describe "#syntax_theme" do
    it "must return Rouge::Themes::Molokai by default" do
      expect(subject.syntax_theme).to be_kind_of(Rouge::Themes::Molokai)
    end
  end

  describe "#syntax_formatter" do
    it "must return Rouge::Formatters::Terminal256 by default" do
      expect(subject.syntax_formatter).to be_kind_of(Rouge::Formatters::Terminal256)
    end

    it "must set the theme to #syntax_theme" do
      expect(subject.syntax_formatter.theme).to be_kind_of(
        subject.syntax_theme.class
      )
    end
  end
end

require 'spec_helper'
require 'ronin/cli/char_set_options'
require 'ronin/cli/command'

describe Ronin::CLI::CharSetOptions do
  module TestCharSetOptions
    class TestCommand < Ronin::CLI::Command
      include Ronin::CLI::CharSetOptions
    end
  end

  let(:command_class) { TestCharSetOptions::TestCommand }
  subject { command_class.new }

  describe ".included" do
    subject { command_class }

    #
    # General options
    #
    it "must define a '-c,--chars' option" do
      expect(subject.options[:chars]).to_not be(nil)
      expect(subject.options[:chars].short).to eq('-c')
      expect(subject.options[:chars].value.type).to be(String)
      expect(subject.options[:chars].value.usage).to eq('CHARS')
      expect(subject.options[:chars].desc).to eq('Searches for all chars in the custom char-set')
    end

    it "must define a '-I,--include-chars' option" do
      expect(subject.options[:include_chars]).to_not be(nil)
      expect(subject.options[:include_chars].short).to eq('-i')
      expect(subject.options[:include_chars].value.type).to be(String)
      expect(subject.options[:include_chars].value.usage).to eq('CHARS')
      expect(subject.options[:include_chars].desc).to eq('Include the additional chars to the char-set')
    end

    it "must define a '-e,--exclude-chars' option" do
      expect(subject.options[:exclude_chars]).to_not be(nil)
      expect(subject.options[:exclude_chars].short).to eq('-e')
      expect(subject.options[:exclude_chars].value.type).to be(String)
      expect(subject.options[:exclude_chars].value.usage).to eq('CHARS')
      expect(subject.options[:exclude_chars].desc).to eq('Exclude the additional chars from the char-set')
    end

    #
    # Character set options
    #
    it "must define a '-N,--numeric' option" do
      expect(subject.options[:numeric]).to_not be(nil)
      expect(subject.options[:numeric].short).to eq('-N')
      expect(subject.options[:numeric].value).to be(nil)
      expect(subject.options[:numeric].desc).to eq('Searches for numeric characters (0-9)')
    end

    it "must define a '-O,--octal' option" do
      expect(subject.options[:octal]).to_not be(nil)
      expect(subject.options[:octal].short).to eq('-O')
      expect(subject.options[:octal].value).to be(nil)
      expect(subject.options[:octal].desc).to eq('Searches for octal characters (0-7)')
    end

    it "must define a '-X,--upper-hex' option" do
      expect(subject.options[:upper_hex]).to_not be(nil)
      expect(subject.options[:upper_hex].short).to eq('-X')
      expect(subject.options[:upper_hex].value).to be(nil)
      expect(subject.options[:upper_hex].desc).to eq('Searches for uppercase hexadecimal (0-9, A-F)')
    end

    it "must define a '-x,--lower-hex' option" do
      expect(subject.options[:lower_hex]).to_not be(nil)
      expect(subject.options[:lower_hex].short).to eq('-x')
      expect(subject.options[:lower_hex].value).to be(nil)
      expect(subject.options[:lower_hex].desc).to eq('Searches for lowercase hexadecimal (0-9, a-f)')
    end

    it "must define a '-H,--hex' option" do
      expect(subject.options[:hex]).to_not be(nil)
      expect(subject.options[:hex].short).to eq('-H')
      expect(subject.options[:hex].value).to be(nil)
      expect(subject.options[:hex].desc).to eq('Searches for hexadecimal chars (0-9, a-f, A-F)')
    end

    it "must define a '--upper-alpha' option" do
      expect(subject.options[:upper_alpha]).to_not be(nil)
      expect(subject.options[:upper_alpha].short).to be(nil)
      expect(subject.options[:upper_alpha].value).to be(nil)
      expect(subject.options[:upper_alpha].desc).to eq('Searches for uppercase alpha chars (A-Z)')
    end

    it "must define a '--lower-alpha' option" do
      expect(subject.options[:lower_alpha]).to_not be(nil)
      expect(subject.options[:lower_alpha].short).to be(nil)
      expect(subject.options[:lower_alpha].value).to be(nil)
      expect(subject.options[:lower_alpha].desc).to eq('Searches for lowercase alpha chars (a-z)')
    end

    it "must define a '--alpha' option" do
      expect(subject.options[:alpha]).to_not be(nil)
      expect(subject.options[:alpha].short).to eq('-A')
      expect(subject.options[:alpha].value).to be(nil)
      expect(subject.options[:alpha].desc).to eq('Searches for alpha chars (a-z, A-Z)')
    end

    it "must define a '--alpha-num' option" do
      expect(subject.options[:alpha_num]).to_not be(nil)
      expect(subject.options[:alpha_num].short).to be(nil)
      expect(subject.options[:alpha_num].value).to be(nil)
      expect(subject.options[:alpha_num].desc).to eq('Searches for alpha-numeric chars (a-z, A-Z, 0-9)')
    end

    it "must define a '-P,--punct' option" do
      expect(subject.options[:punct]).to_not be(nil)
      expect(subject.options[:punct].short).to eq('-P')
      expect(subject.options[:punct].value).to be(nil)
      expect(subject.options[:punct].desc).to eq('Searches for punctuation chars')
    end

    it "must define a '-S,--symbols' option" do
      expect(subject.options[:symbols]).to_not be(nil)
      expect(subject.options[:symbols].short).to eq('-S')
      expect(subject.options[:symbols].value).to be(nil)
      expect(subject.options[:symbols].desc).to eq('Searches for symbolic chars')
    end

    it "must define a '-s,--space' option" do
      expect(subject.options[:space]).to_not be(nil)
      expect(subject.options[:space].short).to eq('-s')
      expect(subject.options[:space].value).to be(nil)
      expect(subject.options[:space].desc).to eq('Searches for all whitespace chars')
    end

    it "must define a '-v,--visible' option" do
      expect(subject.options[:visible]).to_not be(nil)
      expect(subject.options[:visible].short).to eq('-v')
      expect(subject.options[:visible].value).to be(nil)
      expect(subject.options[:visible].desc).to eq('Searches for all visible chars')
    end

    it "must define a '-p,--printable' option" do
      expect(subject.options[:printable]).to_not be(nil)
      expect(subject.options[:printable].short).to eq('-p')
      expect(subject.options[:printable].value).to be(nil)
      expect(subject.options[:printable].desc).to eq('Searches for all printable chars')
    end

    it "must define a '-C,--control' option" do
      expect(subject.options[:control]).to_not be(nil)
      expect(subject.options[:control].short).to eq('-C')
      expect(subject.options[:control].value).to be(nil)
      expect(subject.options[:control].desc).to eq('Searches for all control chars (\\x00-\\x1f, \\x7f)')
    end

    it "must define a '-a,--signed-ascii' option" do
      expect(subject.options[:signed_ascii]).to_not be(nil)
      expect(subject.options[:signed_ascii].short).to eq('-a')
      expect(subject.options[:signed_ascii].value).to be(nil)
      expect(subject.options[:signed_ascii].desc).to eq('Searches for all signed ASCII chars (\\x00-\\x7f)')
    end

    it "must define a '--ascii' option" do
      expect(subject.options[:ascii]).to_not be(nil)
      expect(subject.options[:ascii].short).to be(nil)
      expect(subject.options[:ascii].value).to be(nil)
      expect(subject.options[:ascii].desc).to eq('Searches for all ASCII chars (\\x00-\\xff)')
    end
  end

  describe "#initialize" do
    it "must default #char_set to Chars::VISIBLE" do
      expect(subject.char_set).to be(Chars::VISIBLE)
    end
  end

  describe "#option_parser" do
    #
    # General options
    #
    context "when givne '--chars CHARS'" do
      let(:string) { "ABC" }
      let(:chars)  { string.chars }

      before do
        subject.option_parser.parse(['--chars', string])
      end

      it "must set #char_set to the characters in the given String" do
        expect(subject.char_set).to eq(Chars::CharSet.new(chars))
      end
    end

    context "when givne '-c CHARS'" do
      let(:string) { "ABC" }
      let(:chars)  { string.chars }

      before do
        subject.option_parser.parse(['-c', string])
      end

      it "must set #char_set to the characters in the given String" do
        expect(subject.char_set).to eq(Chars::CharSet.new(chars))
      end
    end

    context "when given '--include-chars CHARS'" do
      let(:string) { " " }
      let(:chars)  { string.chars }

      before do
        subject.option_parser.parse(['--include-chars', string])
      end

      it "must add the characters to #char_set" do
        expect(subject.char_set).to eq(Chars::VISIBLE + chars)
      end
    end

    context "when given '-i CHARS'" do
      let(:string) { " " }
      let(:chars)  { string.chars }

      before do
        subject.option_parser.parse(['-i', string])
      end

      it "must add the characters to #char_set" do
        expect(subject.char_set).to eq(
          Chars::VISIBLE + Chars::CharSet.new(chars)
        )
      end
    end

    context "when given '--exclude-chars CHARS'" do
      let(:string) { "ABC" }
      let(:chars)  { string.chars }

      before do
        subject.option_parser.parse(['--exclude-chars', string])
      end

      it "must remove the characters to #char_set" do
        expect(subject.char_set).to eq(
          Chars::VISIBLE - Chars::CharSet.new(chars)
        )
      end
    end

    context "when given '-e CHARS'" do
      let(:string) { "ABC" }
      let(:chars)  { string.chars }

      before do
        subject.option_parser.parse(['-e', string])
      end

      it "must remove the characters to #char_set" do
        expect(subject.char_set).to eq(
          Chars::VISIBLE - Chars::CharSet.new(chars)
        )
      end
    end

    #
    # Character-set options
    #
    shared_examples_for "char-set option" do |flag,constant|
      describe "when given '#{flag}'" do
        let(:flag) { flag }

        before { subject.option_parser.parse([flag]) }

        it "must set #pattern to Chars::#{constant}" do
          expect(subject.char_set).to be(
            Chars.const_get(constant)
          )
        end
      end
    end

    include_context "char-set option", '--numeric', :NUMERIC
    include_context "char-set option", '-N', :NUMERIC
    include_context "char-set option", '--octal', :OCTAL
    include_context "char-set option", '-O', :OCTAL
    include_context "char-set option", '--upper-hex', :UPPERCASE_HEXADECIMAL
    include_context "char-set option", '-X', :UPPERCASE_HEXADECIMAL
    include_context "char-set option", '--lower-hex', :LOWERCASE_HEXADECIMAL
    include_context "char-set option", '-x', :LOWERCASE_HEXADECIMAL
    include_context "char-set option", '--hex', :HEXADECIMAL
    include_context "char-set option", '-H', :HEXADECIMAL
    include_context "char-set option", '--upper-alpha', :UPPERCASE_ALPHA
    include_context "char-set option", '--lower-alpha', :LOWERCASE_ALPHA
    include_context "char-set option", '--alpha', :ALPHA
    include_context "char-set option", '-A', :ALPHA
    include_context "char-set option", '--alpha-num', :ALPHA_NUMERIC
    include_context "char-set option", '--punct', :PUNCTUATION
    include_context "char-set option", '-P', :PUNCTUATION
    include_context "char-set option", '--symbols', :SYMBOLS
    include_context "char-set option", '-S', :SYMBOLS
    include_context "char-set option", '--space', :SPACE
    include_context "char-set option", '-s', :SPACE
    include_context "char-set option", '--visible', :VISIBLE
    include_context "char-set option", '-v', :VISIBLE
    include_context "char-set option", '--printable', :PRINTABLE
    include_context "char-set option", '-p', :PRINTABLE
    include_context "char-set option", '--control', :CONTROL
    include_context "char-set option", '-C', :CONTROL
    include_context "char-set option", '--signed-ascii', :SIGNED_ASCII
    include_context "char-set option", '-a', :SIGNED_ASCII
    include_context "char-set option", '--ascii', :ASCII
  end
end

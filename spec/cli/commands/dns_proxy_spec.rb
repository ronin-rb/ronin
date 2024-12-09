require 'spec_helper'
require 'ronin/cli/commands/dns_proxy'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::DnsProxy do
  include_examples "man_page"

  let(:nameserver1) { '8.8.8.8' }
  let(:nameserver2) { '4.4.4.4' }

  describe "options" do
    context "when --nameserver is given" do
      before do
        subject.option_parser.parse(
          [
            '--nameserver', nameserver1,
            '--nameserver', nameserver2
          ]
        )
      end

      it "must append the IP address to #nameservers" do
        expect(subject.nameservers).to eq([nameserver1, nameserver2])
      end
    end

    context "when --rule is given" do
      let(:record_type1) { :A }
      let(:name1)        { 'www.example.com' }
      let(:result1)      { '1.2.3.4' }

      let(:record_type2) { :AAAA }
      let(:name2)        { 'www.example.com' }
      let(:result2)      { 'ffff::c0ffee' }

      before do
        subject.option_parser.parse(
          [
            '--rule', "#{record_type1}:#{name1}:#{result1}",
            '--rule', "#{record_type2}:#{name2}:#{result2}"
          ]
        )
      end

      it "must parse and append the result tuple to #rules" do
        expect(subject.rules).to eq(
          [
            [record_type1, name1, result1],
            [record_type2, name2, result2]
          ]
        )
      end
    end
  end

  describe "#initialize" do
    it "must initialize #nameservers to an empty Array" do
      expect(subject.nameservers).to eq([])
    end

    it "must initialize #rules to an empty Array" do
      expect(subject.rules).to eq([])
    end
  end

  describe "#proxy_kwargs" do
    it "must return a Hash containing :rules and #rules" do
      expect(subject.proxy_kwargs).to eq({rules: subject.rules})
    end

    context "when #nameservers is not empty" do
      before do
        subject.nameservers << nameserver1
        subject.nameservers << nameserver2
      end

      it "must include the :nameservers key and #nameservers" do
        expect(subject.proxy_kwargs).to eq(
          {
            rules:       subject.rules,
            nameservers: subject.nameservers
          }
        )
      end
    end
  end

  describe "#parse_record_type" do
    context "when given a DNS record type" do
      let(:record_type) { 'CNAME' }

      it "must return the Symbol version of the DNS record type" do
        expect(subject.parse_record_type(record_type)).to eq(record_type.to_sym)
      end
    end

    context "when given an unknown type" do
      let(:record_type) { 'FOO' }

      it "must raise an OptionParser::InvalidArgument" do
        expect {
          subject.parse_record_type(record_type)
        }.to raise_error(OptionParser::InvalidArgument,"invalid argument: invalid record type: #{record_type.inspect}")
      end
    end
  end

  describe "#parse_record_name" do
    let(:name) { 'www.example.com' }

    it "must return the String" do
      expect(subject.parse_record_name(name)).to eq(name)
    end

    context "when the name starts with a '/' and ends with a '/'" do
      let(:name)   { '/^foo\./' }
      let(:regexp) { /^foo\./ }

      it "must parse the name as a Regex and return a Regexp" do
        expect(subject.parse_record_name(name)).to eq(regexp)
      end

      context "but the Regexp cannot be parsed" do
        let(:name) { '/[abc/' }

        it "must raise an OptionParser::InvalidArgument" do
          expect {
            subject.parse_record_name(name)
          }.to raise_error(OptionParser::InvalidArgument,"invalid argument: invalid Regexp: premature end of char-class: /[abc/")
        end
      end
    end
  end

  describe "#parse_rule_result" do
    described_class::ERROR_CODES.each do |string,symbol|
      context "when given '#{string}'" do
        let(:string) { string }
        let(:symbol) { symbol }

        it "must return a #{symbol.inspect}" do
          expect(subject.parse_rule_result(string)).to eq(symbol)
        end
      end
    end

    context "when given another String" do
      let(:result) { '1.2.3.4' }

      it "must return that String" do
        expect(subject.parse_rule_result(result)).to eq(result)
      end
    end
  end

  describe "#parse_rule" do
    let(:record_type) { :A }
    let(:name)        { 'www.example.com' }
    let(:result)      { '1.2.3.4' }
    let(:rule)        { "#{record_type}:#{name}:#{result}" }

    it "must parse the ':' separated record into a tuple of record type, name, and result" do
      expect(subject.parse_rule(rule)).to eq(
        [record_type, name, result]
      )
    end

    context "when the record type is unknown" do
      let(:record_type) { 'FOO' }

      it "must raise an OptionParser::InvalidArgument" do
        expect {
          subject.parse_rule(rule)
        }.to raise_error(OptionParser::InvalidArgument,"invalid argument: invalid record type: #{record_type.inspect}")
      end
    end

    context "when the name starts with a '/' and ends with a '/'" do
      let(:name)   { '/^foo\./' }
      let(:regexp) { /^foo\./ }

      it "must parse the name field as a Regexp" do
        expect(subject.parse_rule(rule)).to eq(
          [record_type, regexp, result]
        )
      end

      context "but the Regexp cannot be parsed" do
        let(:name) { '/[abc/' }

        it "must raise an OptionParser::InvalidArgument" do
          expect {
            subject.parse_rule(rule)
          }.to raise_error(OptionParser::InvalidArgument,"invalid argument: invalid Regexp: premature end of char-class: /[abc/")
        end
      end
    end

    context "when the result is a DNS error code" do
      let(:result) { :NXDomain }

      it "must map the result to a Symbol" do
        expect(subject.parse_rule(rule)).to eq(
          [record_type, name, result]
        )
      end
    end
  end
end

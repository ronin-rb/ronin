require 'spec_helper'
require 'ronin/cli/commands/asn'
require_relative 'man_page_example'
require 'ronin/support/network/asn/list'
require 'ronin/support/cli/printing'
require 'tempfile'

describe Ronin::CLI::Commands::Asn do
  include_examples "man_page"

  subject { described_class.new }

  let(:ip2asn_truncated) do
    <<~TSV
    223.255.233.0\t223.255.233.255\t140694\tAU\tARAFURA-AS-AP Northern Technology Solutions
    223.255.234.0\t223.255.234.255\t0\tNone\tNot routed
    223.255.235.0\t223.255.235.255\t140694\tAU\tARAFURA-AS-AP Northern Technology Solutions
    223.255.236.0\t223.255.239.255\t56000\tCN\tHERBALIFE-CNDC HERBALIFESHANGHAIMANAGEMENT CO.,LTD.
    223.255.240.0\t223.255.243.255\t55649\tHK\tMETRONET-HK Flat C, 16F, Skyline Tower
    223.255.244.0\t223.255.247.255\t45117\tIN\tINPL-IN-AP Ishans Network
    223.255.248.0\t223.255.251.255\t63199\tUS\tCDSC-AS1
    223.255.252.0\t223.255.253.255\t58519\tCN\tCHINATELECOM-CTCLOUD Cloud Computing Corporation
    223.255.254.0\t223.255.254.255\t55415\tSG\tMBS-SG 4 Shenton Way
    ::\t::1\t0\tNone\tNot routed
    64:ff9b::1:0:0\t100::ffff:ffff:ffff:ffff\t0\tNone\tNot routed
    100:0:0:1::\t2001:0:ffff:ffff:ffff:ffff:ffff:ffff\t0\tNone\tNot routed
    2001:1::\t2001:4:111:ffff:ffff:ffff:ffff:ffff\t0\tNone\tNot routed
    2001:4:112::\t2001:4:112:ffff:ffff:ffff:ffff:ffff\t112\tUS\t-Reserved AS-
    2001:4:113::\t2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff\t0\tNone\tNot routed
    2001:200::\t2001:200:5ff:ffff:ffff:ffff:ffff:ffff\t2500\tJP\tWIDE-BB WIDE Project
    2001:200:600::\t2001:200:6ff:ffff:ffff:ffff:ffff:ffff\t7667\tJP\tKDDLAB KDDI R&D Laboratories, INC.
    2001:200:700::\t2001:200:8ff:ffff:ffff:ffff:ffff:ffff\t2500\tJP\tWIDE-BB WIDE Project
    2001:200:900::\t2001:200:9ff:ffff:ffff:ffff:ffff:ffff\t7660\tJP\tAPAN-JP Asia Pacific Advanced Network - Japan
    2001:200:a00::\t2001:200:dff:ffff:ffff:ffff:ffff:ffff\t2500\tJP\tWIDE-BB WIDE Project
    TSV
  end

  let(:ip2asn_file) do
    Tempfile.new.tap do |file|
      file.write(ip2asn_truncated)
      file.rewind
    end
  end

  after do
    ip2asn_file.close
    ip2asn_file.unlink
  end

  describe '#run?' do
    context "when the file does not exist" do
      before do
        subject.options[:file] = 'nonexistent_file'
        allow(subject).to receive(:download)
        allow(subject).to receive(:print_asn_records)
      end

      it 'calls #download' do
        expect(subject).to receive(:download)
        subject.run
      end
    end
    
    context "when options[:update] is true" do
      before do
        subject.options[:update] = true
        allow(subject).to receive(:update)
        allow(subject).to receive(:print_asn_records)
      end

      it 'calls #update' do
        expect(subject).to receive(:update)
        subject.run
      end
    end

    context "when the file is stale" do
      before do
        allow(Ronin::Support::Network::ASN::List).to receive(:stale?).and_return(true)
        allow(subject).to receive(:update)
        allow(subject).to receive(:print_asn_records)
      end

      it 'calls #update' do
        expect(subject).to receive(:update)
        subject.run
      end
    end

    context "when given default options and an IP address" do
      before do
        subject.options[:ip] = '223.255.233.1'
        allow(subject).to receive(:query_ip).and_return(true)
        allow(subject).to receive(:print_asn_record)
      end

      it "calls #print_asn_record" do
        expect(subject).to receive(:print_asn_record)
        subject.run
      end
    end

    # FIXME (cmhobbs) the use of #exit has caused this to be difficult to test
    pending "when given default options and an invalid IP address"
    # context "when given default options and an invalid IP address" do
    #   before do
    #     subject.options[:ip] = 'invalid'
    #     allow(subject).to receive(:query_ip).and_return(false)
    #     allow(subject).to receive(:exit)
    #   end

    #   it "calls print_error" do
    #     error_message = "could not find a record for the IP: invalid"
    #     expect(Ronin::Support::CLI::Printing).to receive(:print_error)
    #     #expect { subject.run }.to output(error_message)
    #     subject.run
    #   end
    # end
    
    context "when given default options and no IP address" do
      before do
        allow(subject).to receive(:update)
      end

      it "calls print_asn_records" do
        expect(subject).to receive(:print_asn_records)
        subject.run
      end
    end
  end

  describe '#stale?' do
    let(:file) { 'file' }

    before do
      subject.options[:file] = file
    end

    it 'calls Support::Network::ASN::List.stale? with the file' do
      expect(Ronin::Support::Network::ASN::List).to receive(:stale?).with(file)
      subject.stale?
    end
  end

  describe '#download' do
    context "with default parameters" do
      let(:url)  { 'https://iptoasn.com/data/ip2asn-combined.tsv.gz' }
      let(:file) { "#{Dir.home}/.cache/ronin/ronin-support/ip2asn-combined.tsv.gz" }
        
      it 'calls Support::Network::ASN::List.download with default parameters' do
        expect(Ronin::Support::Network::ASN::List).to receive(:download).with(
          url: url, 
          path: file
        )
        subject.download
      end
    end

    context "with optional parameters" do
      let(:url)  { 'http://example.com' }
      let(:file) { 'file' }

      before do 
        subject.options[:url]  = url
        subject.options[:file] = file
      end

      it 'calls Support::Network::ASN::List.download with optional parameters' do
        expect(Ronin::Support::Network::ASN::List).to receive(:download).with(
          url: url, 
          path: file
        )
        subject.download
      end
    end
  end

  describe "#update" do
    context "with default parameters" do
      let(:url)  { 'https://iptoasn.com/data/ip2asn-combined.tsv.gz' }
      let(:file) { "#{Dir.home}/.cache/ronin/ronin-support/ip2asn-combined.tsv.gz" }

      it 'calls Support::Network::ASN::List.update with default parameters' do
        expect(Ronin::Support::Network::ASN::List).to receive(:update).with(
          url: url,
          path: file
        )
        subject.update
      end
    end

    context "with optional parameters" do
      let(:url)  { 'http://example.com' }
      let(:file) { 'file' }

      before do
        subject.options[:url]  = url
        subject.options[:file] = file
      end

      it 'calls Support::Network::ASN::List.update with optional parameters' do
        expect(Ronin::Support::Network::ASN::List).to receive(:update).with(
          url: url,
          path: file
        )
        subject.update
      end
    end
  end

  describe "#list_file" do
    let(:file) { 'file' }

    before do
      subject.options[:file] = file
    end

    it 'calls Support::Network::ASN::List.parse' do
      expect(Ronin::Support::Network::ASN::List).to receive(:parse).with(file)
      subject.list_file
    end
  end

  describe "#query_ip" do
    let(:ip) { '127.0.0.1' }

    it 'calls Support::Network::ASN::List.query_ip' do
      expect(Ronin::Support::Network::ASN).to receive(:query).with(ip)
      subject.query_ip(ip)
    end
  end

  describe "#search_asn_records" do
    before do
      subject.options[:file] = ip2asn_file.path
    end
    
    context "given the ipv4 option" do
      it "returns the ipv4 records" do
        subject.options[:ipv4] = true
        records = subject.search_asn_records
        expect(records).to be_a(Ronin::Support::Network::ASN::RecordSet)
        expect(records.to_a.length).to eq(9)
      end
    end
    
    context "given the ipv6 option" do
      it "returns the ipv6 records" do
        subject.options[:ipv6] = true
        records = subject.search_asn_records
        expect(records).to be_a(Ronin::Support::Network::ASN::RecordSet)
        expect(records.to_a.length).to eq(11)
      end
    end

    context "given a country code" do
      it "returns the records for the country code" do
        subject.options[:country_code] = 'JP'
        records = subject.search_asn_records
        expect(records).to be_a(Ronin::Support::Network::ASN::RecordSet)
        expect(records.to_a.length).to eq(5)
      end
    end

    context "given an ASN number" do
      it "returns the records for the ASN number" do
        subject.options[:number] = 140694
        records = subject.search_asn_records
        expect(records).to be_a(Ronin::Support::Network::ASN::RecordSet)
        expect(records.to_a.length).to eq(2)
      end
    end

    context "given an ASN name" do
      it "returns the records for the ASN name" do
        subject.options[:name] = 'WIDE-BB WIDE Project'
        records = subject.search_asn_records
        expect(records).to be_a(Ronin::Support::Network::ASN::RecordSet)
        expect(records.to_a.length).to eq(3)
      end
    end
  end

  describe "#print_asn_records" do
    before do
      subject.options[:file] = ip2asn_file.path
    end

    it "calls #print_asn_record for each record" do
      records = subject.search_asn_records

      expect(subject).to receive(:print_asn_record).exactly(20).times
      subject.print_asn_records(records)
    end
  end  

  describe "#print_asn_record" do
    context "with the enum_ips option" do
      before do
        subject.options[:enum_ips] = true
        subject.options[:file]     = ip2asn_file.path
      end

      it "prints each IP address in the range" do
        record = subject.search_asn_records.first

        # NOTE: we're not testing output here due to the large number of IPs
        expect(record.range).to receive(:each)
        subject.print_asn_record(record)
      end
    end

    context "with the verbose option set" do
      before do
        subject.options[:verbose] = true
        subject.options[:file]    = ip2asn_file.path
      end

      it "prints the record in verbose format" do
        record = subject.search_asn_records.first

        output(
          "[ AS140694 ]\n\n" \
          "ASN:      140694\n" \
          "IP range: 223.255.233.0 - 223.255.233.255\n" \
          "Country:  AU\n" \
          "Name:     ARAFURA-AS-AP Northern Technology Solutions\n\n"
        ).to_stdout
      end
    end

    context "with default options" do
      before do
        subject.options[:file] = ip2asn_file.path
      end

      it "prints the record in default format" do
        record = subject.search_asn_records.first

        expect { subject.print_asn_record(record) }.to output(
          "223.255.233.0 - 223.255.233.255 AS140694\ (AU) ARAFURA-AS-AP Northern Technology Solutions\n"
        ).to_stdout
      end
    end
  end
end

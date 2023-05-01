require 'spec_helper'
require 'ronin/cli/commands/ip'
require_relative 'man_page_example'

describe Ronin::CLI::Commands::Ip do
  include_examples "man_page"

  let(:localhost)          { "127.0.0.1" }
  let(:localhost_v6)       { "::ffff:127.0.0.1" }
  let(:localhost_v6_short) { "2001:db8:85a3::8a2e:370:7334" }

  describe "#process_value" do
    context "when -r option is given" do
      before { subject.options[:reverse] = true }

      it "will convert and IPv4 address to reverse name format" do
        expect { subject.process_value(localhost) }.to output("1.0.0.127.in-addr.arpa\n").to_stdout
      end

      it "will convert and IPv6 address to reverse name format" do
        expect { subject.process_value(localhost_v6) }.to \
          output("1.0.0.0.0.0.f.7.f.f.f.f.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa\n").to_stdout
      end
    end

    context "when --hex option is given" do
      before { subject.options[:hex] = true }

      it "will convert an IPv4 address to hexadecimal" do
        expect { subject.process_value(localhost) }.to output("0x7f000001\n").to_stdout
      end

      it "will convert an IPv6 address" do
        expect { subject.process_value(localhost_v6) }.to output("0xffff7f000001\n").to_stdout
      end
    end

    context "when --decimal option is given" do
      before { subject.options[:decimal] = true }

      it "will convert an IPv4 address to decimal" do
        expect { subject.process_value(localhost) }.to output("2130706433\n").to_stdout
      end

      it "will convert an IPv6 address" do
        expect { subject.process_value(localhost_v6) }.to output("281472812449793\n").to_stdout
      end
    end

    context "when --octal option is given" do
      before { subject.options[:octal] = true }

      it "will convert an IPv4 address to octal" do
        expect { subject.process_value(localhost) }.to output("017700000001\n").to_stdout
      end

      it "will convert an IPv6 address to octal" do
        expect { subject.process_value(localhost_v6) }.to output("07777757700000001\n").to_stdout
      end
    end

    context "when --binary option is given" do
      before { subject.options[:binary] = true }

      it "will convert an IPv4 address to binary" do
        expect { subject.process_value(localhost) }.to \
          output("1111111000000000000000000000001\n").to_stdout
      end

      it "will convert an IPv6 address to binary" do
        expect { subject.process_value(localhost_v6) }.to \
          output("111111111111111101111111000000000000000000000001\n").to_stdout
      end
    end

    context "when --octal-octet option is given" do
      before { subject.options[:octal_octet] = true }

      it "will convert an IPv4 address to octal by octet" do
        expect { subject.process_value(localhost) }.to output("0177.00.00.01\n").to_stdout
      end

      it "will complain about an IPv6 address" do
        expect(subject).to receive(:print_error).with(
          "called with --octal-octet for #{localhost_v6}"
        )
        expect {
          subject.process_value(localhost_v6)
        }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(1)
        end
      end
    end

    context "when --hex-octet option is given" do
      before { subject.options[:hex_octet] = true }

      it "will convert an IPv4 address to hex by octet" do
        expect { subject.process_value(localhost) }.to output("7f.0.0.1\n").to_stdout
      end

      it "will convert an IPv6 compatible IPv4 address" do
        expect { subject.process_value(localhost_v6) }.to output("::ffff:7f.0.0.1\n").to_stdout
      end

      it "will complain about an IPv6 address" do
        expect(subject).to receive(:print_error).with(
          "called with --hex-octet for #{localhost_v6_short}"
        )
        expect {
          subject.process_value(localhost_v6_short)
        }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(1)
        end
      end
    end

    context "when --ipv6-compat option is given" do
      before { subject.options[:ipv6_compat] = true }

      it "will convert an IPv4 address to an IPv6 compatible address" do
        expect { subject.process_value(localhost) }.to output("::ffff:127.0.0.1\n").to_stdout
      end

      it "will complain about an IPv6 address" do
        expect(subject).to receive(:print_error).with(
          "called with --ipv6-compat for #{localhost_v6}"
        )
        expect {
          subject.process_value(localhost_v6)
        }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(1)
        end
      end
    end

    context "when --ipv6-expanded option is given" do
      before { subject.options[:ipv6_expanded] = true }

      it "will complain about an IPv4 address" do
        expect(subject).to receive(:print_error).with(
          "called with --ipv6-expanded for #{localhost}"
        )
        expect {
          subject.process_value(localhost)
        }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(1)
        end
      end

      it "will expand a shortened or compressed IPv6 address" do
        expect { subject.process_value(localhost_v6_short) }.to output("2001:0db8:85a3:0000:0000:8a2e:0370:7334\n").to_stdout
      end

      it "will expand an IPv6 compatible IPv4 address" do
        expect { subject.process_value(localhost_v6) }.to output("0000:0000:0000:0000:0000:ffff:7f00:0001\n").to_stdout
      end
    end
  end

  describe "#format_ip" do
    let(:ip)         { Ronin::Support::Network::IP.new(localhost) }
    let(:ipv6)       { Ronin::Support::Network::IP.new(localhost_v6) }
    let(:ipv6_short) { Ronin::Support::Network::IP.new(localhost_v6_short) }

    context "when options[:hex] is present" do
      before { subject.options[:hex] = true }

      it "will convert an IPv4 address to hexadecimal" do
        expect(subject.format_ip(ip)).to eq("0x7f000001")
      end

      it "will convert an IPv6 address" do
        expect(subject.format_ip(ipv6)).to eq("0xffff7f000001")
      end
    end

    context "when options[:decimal] is present" do
      before { subject.options[:decimal] = true }

      it "will convert an IPv4 address to decimal" do
        expect(subject.format_ip(ip)).to eq("2130706433")
      end

      it "will convert an IPv6 address to decimal" do
        expect(subject.format_ip(ipv6)).to eq("281472812449793")
      end
    end

    context "when options[:octal] is present" do
      before { subject.options[:octal] = true }

      it "will convert an IPv4 address to octal" do
        expect(subject.format_ip(ip)).to eq("017700000001")
      end

      it "will convert an IPv6 address to octal" do
        expect(subject.format_ip(ipv6)).to eq("07777757700000001")
      end
    end

    context "when options[:binary] is present" do
      before { subject.options[:binary] = true }

      it "will convert an IPv4 address to binary" do
        expect(subject.format_ip(ip)).to eq("1111111000000000000000000000001")
      end

      it "will convert an IPv6 address to binary" do
        expect(subject.format_ip(ipv6)).to \
          eq("111111111111111101111111000000000000000000000001")
      end
    end

    context "when options[:octal_octet] is present" do
      before { subject.options[:octal_octet] = true }

      it "will convert an IPv4 address to octal by octet" do
        expect(subject.format_ip(ip)).to eq("0177.00.00.01")
      end
    end

    context "when options[:hex_octet] is present" do
      before { subject.options[:hex_octet] = true }

      it "will convert an IPv4 address to hex by octet" do
        expect(subject.format_ip(ip)).to eq("7f.0.0.1")
      end

      it "will convert an IPv6 compatible IPv4 address by octet" do
        expect(subject.format_ip(ipv6)).to eq("::ffff:7f.0.0.1")
      end
    end

    context "when options[:ipv6_compat] is present" do
      before { subject.options[:ipv6_compat] = true }

      it "will convert an IPv4 address to an IPv6 compatible address" do
        expect(subject.format_ip(ip)).to eq("::ffff:127.0.0.1")
      end
    end

    context "when --ipv6-expanded option is given" do
      before { subject.options[:ipv6_expanded] = true }

      it "will expand a shortened or compressed IPv6 address" do
        expect(subject.format_ip(ipv6_short)).to eq("2001:0db8:85a3:0000:0000:8a2e:0370:7334")
      end

      it "will expand an IPv6 compatible IPv4 address" do
        expect(subject.format_ip(ipv6)).to eq("0000:0000:0000:0000:0000:ffff:7f00:0001")
      end
    end
  end
end

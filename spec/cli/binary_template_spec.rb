require 'spec_helper'
require 'ronin/cli/binary_template'
require 'ronin/cli/command'

describe Ronin::CLI::BinaryTemplate do
  module TestBinaryTemplate
    class TestCommand < Ronin::CLI::Command
      include Ronin::CLI::BinaryTemplate
    end
  end

  let(:command_class) { TestBinaryTemplate::TestCommand }
  subject { command_class.new }

  describe "#parse_type" do
    context "when given a single C type" do
      it "must return the C type as a Symbol" do
        expect(subject.parse_type('int32')).to eq(:int32)
      end
    end

    context "when given a C array type" do
      it "must return the C type as an Array of a Symbol and an array length" do
        expect(subject.parse_type('int32[4]')).to eq([:int32, 4])
      end

      context "but the C array does not have a length" do
        it "must return the C type as an unbounded Range" do
          expect(subject.parse_type('int32[]')).to eq(:int32..)
        end
      end
    end
  end

  describe "#build_template" do
    let(:types) { [:uint32, [:char, 4]] }

    it "must create a Ronin::Support::Binary::Template object with the given types" do
      template = subject.build_template(types)

      expect(template).to be_kind_of(Ronin::Support::Binary::Template)
      expect(template.fields).to eq(types)
    end

    context "when --endian is given" do
      let(:endian) { :big }

      before { subject.options[:endian] = endian }

      it "must set the #endian of the template object" do
        template = subject.build_template(types)

        expect(template.endian).to eq(endian)
      end
    end

    context "when --arch is given" do
      let(:arch) { :arm_be }

      before { subject.options[:arch] = arch }

      it "must set the #arch of the template object" do
        template = subject.build_template(types)

        expect(template.arch).to eq(arch)
      end
    end

    context "when --os is given" do
      let(:os) { :macos }

      before { subject.options[:os] = os }

      it "must set the #os of the template object" do
        template = subject.build_template(types)

        expect(template.os).to eq(os)
      end
    end

    context "when given an unknown type" do
      let(:unknown_type) { :foo }
      let(:types)        { [unknown_type] }

      it "must print an error and exit with -1" do
        expect(subject).to receive(:print_error).with("unknown type: #{unknown_type.inspect}")
        expect(subject).to receive(:exit).with(1)

        subject.build_template(types)
      end
    end
  end
end

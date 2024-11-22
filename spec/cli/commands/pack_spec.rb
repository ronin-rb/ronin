require 'spec_helper'
require 'ronin/cli/commands/pack'
require_relative 'man_page_example'

require 'tempfile'

describe Ronin::CLI::Commands::Pack do
  include_examples "man_page"

  describe "options" do
    context "when given --hexdump" do
      it "must require 'hexdump'" do
        expect(subject).to receive(:require).with('hexdump')

        subject.option_parser.parse(%w[--hexdump])
      end
    end
  end

  describe "#parse_int" do
    context "when given a number" do
      let(:int)    { 42 }
      let(:string) { '42' }

      it "must return the parsed Integer" do
        expect(subject.parse_int(string)).to eq(int)
      end
    end

    context "when given an octal number" do
      let(:int)    { 0o10 }
      let(:string) { '010' }

      it "must return the parsed octal Integer" do
        expect(subject.parse_int(string)).to eq(int)
      end
    end

    context "when given a 0x hexadecimal number" do
      let(:int)    { 0xc0ffee }
      let(:string) { '0xc0ffee' }

      it "must return the parsed hex Integer" do
        expect(subject.parse_int(string)).to eq(int)
      end
    end

    context "when given a 0b binary number" do
      let(:int)    { 0b1101 }
      let(:string) { '0b1101' }

      it "must return the parsed binary Integer" do
        expect(subject.parse_int(string)).to eq(int)
      end
    end

    context "when given a non-number" do
      let(:string) { 'foo' }

      it "must print an error and exit with -1" do
        expect(subject).to receive(:print_error).with("cannot parse integer: #{string}")

        expect {
          subject.parse_int(string)
        }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(-1)
        end
      end
    end
  end

  describe "#parse_float" do
    context "when given an integer number" do
      let(:float)  { 10.0 }
      let(:string) { '10' }

      it "must return a parsed Float" do
        expect(subject.parse_float(string)).to eq(float)
      end
    end

    context "when given a floating point number" do
      let(:float)  { 10.5 }
      let(:string) { '10.5' }

      it "must return a parsed Float" do
        expect(subject.parse_float(string)).to eq(float)
      end
    end

    context "when given a non-number" do
      let(:string) { 'foo' }

      it "must print an error and exit with -1" do
        expect(subject).to receive(:print_error).with("cannot parse float: #{string}")

        expect {
          subject.parse_float(string)
        }.to raise_error(SystemExit) do |error|
          expect(error.status).to eq(-1)
        end
      end
    end
  end

  describe "#parse_types_and_values" do
    let(:types) do
      [:char, :int, :uint, :float, :string, [:int, 4]]
    end

    let(:values) do
      %w[A -1 42 1.5 abc 1,2,4,8]
    end

    let(:args) do
      %w[char:A int:-1 uint:42 float:1.5 string:abc int[4]:1,2,4,8]
    end

    it "must parse the arguments and split them into types and values" do
      expect(subject.parse_types_and_values(args)).to eq(
        [types, values]
      )
    end
  end

  describe "#parse_values" do
    let(:types) do
      [
        Ronin::Support::Binary::CTypes::CHAR,
        Ronin::Support::Binary::CTypes::INT,
        Ronin::Support::Binary::CTypes::UINT,
        Ronin::Support::Binary::CTypes::FLOAT,
        Ronin::Support::Binary::CTypes::STRING,
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::INT, 4
        )
      ]
    end

    let(:values) do
      %w[A -1 42 1.5 abc 1,2,4,8]
    end

    it "must parse the values based on the C types" do
      expect(subject.parse_values(types,values)).to eq(
        ['A', -1, 42, 1.5, 'abc', [1, 2, 4, 8]]
      )
    end
  end

  describe "#parse_value" do
    context "when the C type is an int type" do
      let(:ctype)  { Ronin::Support::Binary::CTypes::INT }
      let(:int)    { 42 }
      let(:string) { int.to_s }

      it "must return the parsed Integer" do
        expect(subject.parse_value(ctype,string)).to eq(int)
      end
    end

    context "when the C type is an uint type" do
      let(:ctype)  { Ronin::Support::Binary::CTypes::UINT }
      let(:uint)   { 42 }
      let(:string) { uint.to_s }

      it "must return the parsed Integer" do
        expect(subject.parse_value(ctype,string)).to eq(uint)
      end
    end

    context "when the C type is an float type" do
      let(:ctype)  { Ronin::Support::Binary::CTypes::FLOAT }
      let(:float)  { 10.5 }
      let(:string) { float.to_s }

      it "must return the parsed Float" do
        expect(subject.parse_value(ctype,string)).to eq(float)
      end
    end

    context "when the C type is a char type" do
      let(:ctype) { Ronin::Support::Binary::CTypes::CHAR }
      let(:char)  { 'A' }

      it "must return the given String" do
        expect(subject.parse_value(ctype,char)).to eq(char)
      end
    end

    context "when the C type is a string type" do
      let(:ctype)  { Ronin::Support::Binary::CTypes::STRING }
      let(:string) { 'abc' }

      it "must return the given String" do
        expect(subject.parse_value(ctype,string)).to eq(string)
      end
    end

    context "when the C type is an array type" do
      let(:ctype) do
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::INT, 4
        )
      end

      let(:array)  { [1,2,4,8] }
      let(:string) { array.join(',') }

      it "must return the parsed Array" do
        expect(subject.parse_value(ctype,string)).to eq(array)
      end
    end

    context "when the C type is an array object type" do
      let(:ctype) do
        Ronin::Support::Binary::CTypes::ArrayObjectType.new(
          Ronin::Support::Binary::CTypes::ArrayType.new(
            Ronin::Support::Binary::CTypes::INT, 4
          )
        )
      end

      let(:array)  { [1,2,4,8] }
      let(:string) { array.join(',') }

      it "must return the parsed Array" do
        expect(subject.parse_value(ctype,string)).to eq(array)
      end
    end

    context "when the C type is an unbounded array type" do
      let(:ctype) do
        Ronin::Support::Binary::CTypes::FlexibleArrayType.new(
          Ronin::Support::Binary::CTypes::INT
        )
      end

      let(:array)  { [1,2,4,8] }
      let(:string) { array.join(',') }

      it "must return the parsed Array" do
        expect(subject.parse_value(ctype,string)).to eq(array)
      end
    end

    context "when an unrecognized C type is given" do
      let(:ctype) do
        Ronin::Support::Binary::CTypes::Type.new(pack_string: 'Z*')
      end
      let(:string) { '?' }

      it do
        expect {
          subject.parse_value(ctype,string)
        }.to raise_error(NotImplementedError,"unable to parse value for CType #{ctype.class}")
      end
    end
  end

  describe "#parse_array_value" do
    let(:string) { '1,2,4,8' }

    context "when the given C array type is bounded" do
      let(:ctype) do
        Ronin::Support::Binary::CTypes::ArrayType.new(
          Ronin::Support::Binary::CTypes::INT, 4
        )
      end

      it "must return an Array of parsed values" do
        array = subject.parse_array_value(ctype,string)

        expect(array).to eq([1, 2, 4, 8])
      end

      context "but the number of elements is less than the C array length" do
        let(:string) { '1,2' }

        it "must return an Array padded with uninitialized values of the C array element type" do
          array = subject.parse_array_value(ctype,string)

          expect(array).to eq([1, 2, 0, 0])
        end
      end
    end

    context "when the given C array type is unbounded" do
      let(:ctype) do
        Ronin::Support::Binary::CTypes::FlexibleArrayType.new(
          Ronin::Support::Binary::CTypes::INT
        )
      end

      it "must return an Array of parsed values" do
        array = subject.parse_array_value(ctype,string)

        expect(array).to eq([1, 2, 4, 8])
      end
    end
  end

  describe "#write_output" do
    let(:data) { "\x00\x00\x00\xff".b }

    it "must write the data to stdout" do
      expect(subject.stdout).to receive(:write).with(data)

      subject.write_output(data)
    end

    context "when the --output option is given" do
      let(:tempfile) { Tempfile.new('ronin-pack-output') }
      let(:output)   { tempfile.path }

      before { subject.options[:output] = output }

      it "must write the data to the --output file" do
        subject.write_output(data)

        expect(File.binread(output)).to eq(data)
      end
    end
  end
end

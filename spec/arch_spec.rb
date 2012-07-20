require 'spec_helper'

require 'ronin/arch'

describe Arch do
  describe "validations" do
    it "should require a name, endian and address_length attributes" do
      subject.should_not be_valid

      subject.name = 'future'
      subject.should_not be_valid

      subject.endian = 'little'
      subject.should_not be_valid

      subject.address_length = 4
      subject.should be_valid
    end

    describe "name" do
      before do
        described_class.create(
          :name           => 'cats',
          :endian         => 'little',
          :address_length => 4
        )
      end

      subject do
        described_class.new(
          :name           => 'cats',
          :endian         => 'big',
          :address_length => 4
        )
      end

      it "should require a unique name" do
        subject.should_not be_valid
      end
    end

    describe "endian" do
      subject do
        described_class.new(
          :name           => 'test',
          :address_length => 4
        )
      end

      it "should accept 'little'" do
        subject.endian = 'little'
        subject.should be_valid
      end

      it "should accept 'big'" do
        subject.endian = 'big'
        subject.should be_valid
      end

      context "otherwise" do
        it { should_not be_valid }
      end
    end
  end

  describe "predefined archs" do
    subject { described_class }

    it "should provide built-in archs" do
      subject.i386.should_not be_nil
    end

    it "should allow custom names for built-in archs" do
      subject.x86_64.name.should == 'x86-64'
    end
  end
end

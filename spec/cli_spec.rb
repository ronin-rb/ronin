require 'spec_helper'
require 'ronin/cli'

describe Ronin::CLI do
  describe "version" do
    subject { described_class }

    it "must define the version" do
      expect(subject.version).to eq(Ronin::VERSION)
    end
  end

  describe "command_aliases" do
    subject { described_class }

    it "must alias 'enc' to 'encode'" do
      expect(subject.command_aliases['enc']).to eq('encode')
    end

    it "must alias 'dec' to 'decode'" do
      expect(subject.command_aliases['dec']).to eq('decode')
    end

    it "must alias 'nc' to 'netcat'" do
      expect(subject.command_aliases['nc']).to eq('netcat')
    end
  end
end

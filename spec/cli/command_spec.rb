require 'spec_helper'
require 'ronin/cli/command'

describe Ronin::CLI::Command do
  it { expect(described_class).to be < Ronin::Core::CLI::Command }

  it "must set .man_dir" do
    expect(described_class.man_dir).to eq(File.join(Ronin::ROOT,'man'))
  end
end

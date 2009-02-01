require 'ronin/target'

require 'helpers/database'

describe Target do
  it "should require an arch and a platform" do
    @target = Target.new
    @target.should_not be_valid

    @target.arch = Arch.i386
    @target.should_not be_valid

    @target.os = OS.linux_version('2.6.11')
    @target.should be_valid
  end
end

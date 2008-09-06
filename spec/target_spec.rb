require 'ronin/target'

describe Target do
  it "should require an arch and a platform" do
    @target = Target.new
    @target.should_not be_valid

    @target.arch = Arch.i386
    @target.should_not be_valid

    @target.platform = Platform.linux('2.6.11')
    @target.should be_valid
  end
end

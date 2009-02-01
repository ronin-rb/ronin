require 'ronin/os'

require 'helpers/database'

describe OS do
  it "should require os and version attributes" do
    @os = OS.new
    @os.should_not be_valid

    @os.name = 'test'
    @os.should_not be_valid

    @os.version = '0.0.1'
    @os.should be_valid
  end

  it "should provide methods for built-in OSes" do
    OS.linux.should_not be_nil
  end

  it "should provide methods for creating OSes with versions" do
    OS.linux_version('2.6.11').should be_valid
  end
end

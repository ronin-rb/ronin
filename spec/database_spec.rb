require 'ronin/database'

require 'spec_helper'

describe Database do
  it "should auto_upgrade the Author model" do
    Author.should be_auto_upgraded
  end

  it "should auto_upgrade the License model" do
    License.should be_auto_upgraded
  end

  it "should auto_upgrade the Arch model" do
    Arch.should be_auto_upgraded
  end

  it "should auto_upgrade the OS model" do
    OS.should be_auto_upgraded
  end
end

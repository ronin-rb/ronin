require 'ronin/license'

require 'helpers/database'

describe License do
  it "should require name and description attributes" do
    @license = License.new
    @license.should_not be_valid

    @license.name = 'joke'
    @license.should_not be_valid

    @license.description = "yep, it's a joke."
    @license.should be_valid
  end

  it "should provide built-in licenses"do
    License.cc_by.should_not be_nil
  end
end

require 'ronin/extensions/array'

describe Array do
  it "should provide Array#power_set" do
    [].respond_to?(:power_set).should == true
  end

  describe "power_set" do
    before(:all) do
      @array = [1,2,3]
      @set = @array.power_set
    end

    it "should contain an empty set" do
      @set.include?([]).should == true
    end

    it "should contain singleton sets of all the elements" do
      @set.include?([1]).should == true
      @set.include?([2]).should == true
      @set.include?([3]).should == true
    end

    it "should include the sub-sets of the original set" do
      @set.include?([1,2]).should == true
      @set.include?([1,3]).should == true
      @set.include?([2,3]).should == true
    end

    it "should include the original set itself" do
      @set.include?(@array).should == true
    end
  end
end

require 'ronin/extensions/array'

describe Array do
  it "should provide Array#power_set" do
    [].should respond_to(:power_set)
  end

  describe "power_set" do
    before(:all) do
      @array = [1,2,3]
      @set = @array.power_set
    end

    it "should contain an empty set" do
      @set.should include([])
    end

    it "should contain singleton sets of all the elements" do
      @set.should include([1])
      @set.should include([2])
      @set.should include([3])
    end

    it "should include the sub-sets of the original set" do
      @set.should include([1,2])
      @set.should include([1,3])
      @set.should include([2,3])
    end

    it "should include the original set itself" do
      @set.should include(@array)
    end
  end
end

require 'ronin/author'

describe Author do
  it "should have a default name" do
    @author = Author.new
    @author.name.should == Author::ANONYMOUSE
  end
end

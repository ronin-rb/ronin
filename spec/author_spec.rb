require 'ronin/author'

require 'helpers/database'

describe Author do
  it "should have a String representation" do
    author = Author.new(:name => 'test')
    author.to_s.should == 'test'
  end
end

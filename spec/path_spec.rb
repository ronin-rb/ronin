require 'ronin/path'

require 'spec_helper'

describe Path do
  before(:all) do
    @n = 7
    @range = (7..10)
    @sub_path = File.join('one','two')
    @sub_directory = 'three'
  end

  it "should inherit from Pathname" do
    Path.superclass.should == Pathname
  end

  it "should create directory-escaping paths" do
    Path.up(@n).to_s.should == File.join(*(['..'] * @n))
  end

  it "should create a range of directory-escaping paths" do
    Path.up(@range).should == @range.map { |i| Path.up(i) }
  end

  it "should join with sub-paths" do
    Path.up(@n).join(@sub_path).to_s.should == File.join(Path.up(@n),@sub_path)
  end

  it "should join with a sub-directory" do
    (Path.up(@n) / @sub_directory).to_s.should == File.join(Path.up(@n),@sub_directory)
  end
end

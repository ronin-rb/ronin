require 'ronin/static/finders'

require 'spec_helper'
require 'static/helpers/static'

describe Static::Finders do
  before(:all) do
    @example = StaticClass.new
  end

  it "should find a file" do
    @example.instance_eval {
      find_static_file('one.txt')
    }.should == File.join(STATIC_DIRS[0],'one.txt')
  end

  it "should find a directory" do
    @example.instance_eval {
      find_static_dir('dir')
    }.should == File.join(STATIC_DIRS[0],'dir')
  end

  it "should find a file based on a pattern" do
    @example.instance_eval {
      static_glob('*/*.txt')
    }.should == [File.join(STATIC_DIRS[0],'dir','two.txt')]
  end

  it "should find all matching files" do
    @example.instance_eval {
      find_static_files('dir/two.txt')
    }.should == [
      File.join(STATIC_DIRS[0],'dir','two.txt'),
      File.join(STATIC_DIRS[1],'dir','two.txt')
    ]
  end

  it "should find all matching directories" do
    @example.instance_eval {
      find_static_dirs('dir')
    }.should == [
      File.join(STATIC_DIRS[0],'dir'),
      File.join(STATIC_DIRS[1],'dir')
    ]
  end

  it "should find all paths matching a pattern" do
    @example.instance_eval {
      static_glob_all('*/*.txt')
    }.should == [
      File.join(STATIC_DIRS[0],'dir','two.txt'),
      File.join(STATIC_DIRS[1],'dir','two.txt')
    ]
  end
end

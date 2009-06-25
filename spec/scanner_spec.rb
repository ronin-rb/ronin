require 'ronin/scanner'

require 'spec_helper'
require 'classes/example_scanner'
require 'classes/another_scanner'

describe Scanner do
  before(:all) do
    @example_scanner = ExampleScanner.new
    @another_scanner = AnotherScanner.new
  end

  it "should register scanner tests with a class" do
    ExampleScanner.scanners.should_not be_empty
  end

  it "should group multiple scanner tests into categories by name" do
    ExampleScanner.scanners[:test2].length.should == 2
  end

  it "should separate scanner tests between inherited classes" do
    ExampleScanner.scanners[:test1].length.should == 1
    ExampleScanner.scanners[:test3].should be_nil

    AnotherScanner.scanners[:test1].length.should == 1
    AnotherScanner.scanners[:test3].length.should == 1
  end

  it "should specify if the scanner defines a certain category of tests" do
    ExampleScanner.scans_for?(:test1).should == true
    AnotherScanner.scans_for?(:test2).should == true
  end

  it "should specify the category names of all tests" do
    ExampleScanner.scans_for.should == Set[:test1, :test2]
    AnotherScanner.scans_for.should == Set[:test1, :test2, :test3]
  end
end

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

  it "should scan the targets and return the discovered results" do
    @example_scanner.scan.should == {:test1 => [1], :test2 => [2, 2]}

    @another_scanner.scan.should == {
      :test1 => [1, 1],
      :test2 => [2, 2],
      :test3 => [3]
    }
  end

  it "should allow for the scanning for specific categories" do
    @example_scanner.scan(:test1).should == {:test1 => [1]}

    @another_scanner.scan(:test1, :test3).should == {
      :test1 => [1, 1],
      :test3 => [3]
    }
  end

  it "should return an empty Array for unknown scan categories" do
    @example_scanner.scan(:test3).should == {:test3 => []}
  end

  it "should define convenience methods for scanning a category" do
    ExampleScanner.method_defined?(:test1_scan).should == true
  end

  it "should return a singleton Hash when calling convenience methods" do
    @example_scanner.test1_scan.should == {:test1 => [1]}
  end
end

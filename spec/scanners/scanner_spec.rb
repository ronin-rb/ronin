require 'ronin/scanners/scanner'

require 'spec_helper'
require 'scanners/classes/example_scanner'
require 'scanners/classes/another_scanner'

describe Scanners::Scanner do
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
    ExampleScanner.scanners[:fail].length.should == 1
    ExampleScanner.scanners[:test3].should be_nil

    AnotherScanner.scanners[:test1].length.should == 1
    AnotherScanner.scanners[:test3].length.should == 1
    AnotherScanner.scanners[:fail].length.should == 1
  end

  it "should specify if the scanner defines a certain category of tests" do
    ExampleScanner.scans_for?(:test1).should == true
    AnotherScanner.scans_for?(:test2).should == true
  end

  it "should return all scanner tests within a category" do
    tests = ExampleScanner.scanners_in(:test2)

    tests.length.should == 2
    tests.all? { |test| test.kind_of?(Proc) }.should == true
  end

  it "should specify the category names of all tests" do
    ExampleScanner.scans_for.should == Set[:test1, :test2, :fail]
    AnotherScanner.scans_for.should == Set[:test1, :test2, :test3, :fail]
  end

  it "should scan each target and return the discovered results" do
    @example_scanner.scan.should == {
      :test1 => [1],
      :test2 => [2, 4],
      :fail => []
    }

    @another_scanner.scan.should == {
      :test1 => [1, 1],
      :test2 => [2, 4],
      :test3 => [3],
      :fail => []
    }
  end

  it "should scan each target and pass back results" do
    results = {:test1 => [1], :test2 => [2, 4]}

    @example_scanner.scan do |category,result|
      results.has_key?(category).should == true
      results[category].include?(result).should == true
    end
  end

  it "should allow for the scanning for specific categories" do
    @example_scanner.scan(:test1 => true).should == {:test1 => [1]}

    @another_scanner.scan(:test1 => true, :test3 => true).should == {
      :test1 => [1, 1],
      :test3 => [3]
    }
  end

  it "should return an empty Array for a failed scan" do
    @example_scanner.scan(:fail => true).should == {:fail => []}
  end

  it "should not scan a category if the category information is false" do
    @example_scanner.scan(:test1 => false).should == {}
  end

  it "should not scan a category if the category information is nil" do
    @example_scanner.scan(:test1 => nil).should == {}
  end

  it "should raise an UnknownCategory for unknown scan categories" do
    lambda {
      @example_scanner.scan(:test3 => true)
    }.should raise_error(Scanners::UnknownCategory)
  end

  it "should define a convenience method for only scanning a category" do
    ExampleScanner.method_defined?(:test1_scan).should == true
  end

  it "should return an Array when calling convenience methods" do
    @example_scanner.test1_scan.should == [1]
  end

  it "should pass back results from convenience methods" do
    @example_scanner.test1_scan do |result|
      result.should == 1
    end
  end

  it "should return an empty Array for failed convenience scans" do
    @example_scanner.fail_scan.should == []
  end

  it "should define a convenience method for returning the first result" do
    @example_scanner.get_test2.should == 2
  end

  it "should return nil when there is no first result to return" do
    @example_scanner.get_fail.should be_nil
  end
end

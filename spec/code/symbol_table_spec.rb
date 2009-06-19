require 'ronin/code/symbol_table'

require 'spec_helper'

describe Code::SymbolTable do
  before(:each) do
    @one = [:a, :b, :c]
    @two = {:one => 1, :two => 2}

    @table = Code::SymbolTable.new(:one => @one, :two => @two)
  end

  it "should have symbols" do
    @table.has_symbol?(:one).should == true
    @table.has_symbol?(:two).should == true
  end

  it "should provide transparent access to the symbol values" do
    @table[:one].should == [:a, :b, :c]

    @table[:one] = [:d, :e]
    @table[:one].should == [:d, :e]
  end

  it "should provide direct access to the symbols" do
    @table.symbol(:two).value.should == {:one => 1, :two => 2}
  end

  it "should be able to retrieve symbols and actual values" do
    @table.symbols.each do |name,value|
      @table.symbol(name).value.should == value
    end
  end

  it "should be able to set symbols en-mass" do
    @table.symbols = {:three => 3, :four => 4}

    @table[:three].should == 3
    @table[:four].should == 4
  end

  it "should display the values of the symbols when inspected" do
    @table.inspect.should == '{:one=>[:a, :b, :c], :two=>{:one=>1, :two=>2}}'
  end
end

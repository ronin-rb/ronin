require 'ronin/web/extensions/hpricot'

require 'spec_helper'

describe Hpricot do
  before(:all) do
    @doc = Hpricot(%{<html><head><title>test</title></head><body><p><b>This is a test</b> html <i>page</i>.</p></div></body></html>})

    @edited_doc = Hpricot(%{<html><head><title>test</title></head><body><p><b>This is a test</b> html page.</p></div></body></html>})
  end

  it "should be able to test if two elements are equal" do
    elem1 = @doc.at('b')
    elem2 = @edited_doc.at('b')

    (elem1 == elem2).should == true
  end

  it "should be able to compare two elements" do
    elem1 = @doc.at('p')
    elem2 = @edited_doc.at('p')

    (elem1 > elem2).should == true
    (elem2 < elem1).should == true
  end

  it "should provide a count of all sub-children" do
    @doc.count_children.should == 13
  end

  it "should be able to test if two Hpricot documents are equal" do
    (@doc == @doc).should == true
  end

  it "should be able to compare two Hpricot documents" do
    (@doc > @edited_doc).should == true
    (@edited_doc < @doc).should == true
  end
end

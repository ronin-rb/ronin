require 'ronin/extensions/symbol'

require 'spec_helper'

describe Symbol do
  it "should humanize single-word symbols" do
    :what.humanize.should == 'What'
  end

  it "should humanize multi-word symbols" do
    :what_what.humanize.should == 'What What'
  end
end

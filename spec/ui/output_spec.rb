require 'spec_helper'
require 'ronin/ui/output'

describe UI::Output do
  it "should be quiet by default" do
    should be_quiet
  end

  it "may become verbose or quiet" do
    subject.verbose = true
    should be_verbose
    should_not be_quiet

    subject.verbose = false
    should be_quiet
    should_not be_verbose
  end

  it "may become silent or quiet" do
    subject.silent = false
    should be_quiet
    should_not be_silent

    subject.silent = true
    should be_silent
    should_not be_quiet
  end
end

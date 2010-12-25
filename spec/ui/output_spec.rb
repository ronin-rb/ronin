require 'spec_helper'
require 'ronin/ui/output'

describe UI::Output do
  it "should be quiet by default" do
    should be_quiet
  end

  it "may become verbose" do
    subject.verbose!

    should be_verbose
    should_not be_quiet
    should_not be_silent
  end

  it "may become quiet" do
    subject.quiet!

    should be_quiet
    should_not be_silent
    should_not be_verbose
  end

  it "may become silent" do
    subject.silent!

    should be_silent
    should_not be_quiet
    should_not be_verbose
  end
end

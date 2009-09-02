require 'ronin/ui/output'

require 'spec_helper'

describe UI::Output do
  it "should be quiet by default" do
    UI::Output.should be_quiet
  end

  it "may become verbose or quiet" do
    UI::Output.verbose = true
    UI::Output.should be_verbose
    UI::Output.should_not be_quiet

    UI::Output.verbose = false
    UI::Output.should be_quiet
    UI::Output.should_not be_verbose
  end

  it "may become silent or quiet" do
    UI::Output.silent = false
    UI::Output.should be_quiet
    UI::Output.should_not be_silent

    UI::Output.silent = true
    UI::Output.should be_silent
    UI::Output.should_not be_quiet
  end
end

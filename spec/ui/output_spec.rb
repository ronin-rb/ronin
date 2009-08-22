require 'ronin/ui/output'

require 'spec_helper'

describe UI::Output do
  it "should be disabled by default" do
    UI::Output.should be_quiet
  end

  it "may be enabled and disabled" do
    UI::Output.verbose!
    UI::Output.should be_verbose

    UI::Output.quiet!
    UI::Output.should be_quiet
  end
end

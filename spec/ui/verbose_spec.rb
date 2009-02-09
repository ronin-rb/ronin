require 'ronin/ui/verbose'

require 'spec_helper'

describe UI::Verbose do
  it "should be disabled by default" do
    UI::Verbose.should be_disabled
  end

  it "may be enabled and disabled" do
    UI::Verbose.enable!
    UI::Verbose.should be_enabled

    UI::Verbose.disable!
    UI::Verbose.should be_disabled
  end
end

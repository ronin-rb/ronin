require 'ronin/ui/diagnostics'

require 'spec_helper'

describe UI::Diagnostics do
  it "should be disabled by default" do
    UI::Diagnostics.should be_disabled
  end

  it "may be enabled and disabled" do
    UI::Diagnostics.enable!
    UI::Diagnostics.should be_enabled

    UI::Diagnostics.disable!
    UI::Diagnostics.should be_disabled
  end
end

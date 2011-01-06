require 'spec_helper'
require 'ronin/url_scheme'

describe URLScheme do
  before(:all) { @http = URLScheme.create(:name => 'http') }

  it "should require a name" do
    scheme = URLScheme.new

    scheme.should_not be_valid
  end

  it "should require a unique name" do
    scheme = URLScheme.new(:name => 'http')

    scheme.should_not be_valid
  end
end

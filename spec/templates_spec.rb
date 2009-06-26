require 'ronin/templates'

require 'spec_helper'
require 'classes/uses_templates'

describe Templates do
  before(:all) do
    @uses_templates = UsesTemplates.new
    @uses_templates.x = 2
    @uses_templates.y = 3
  end

  it "should render inline ERB templates" do
    @uses_templates.erb(%{<%= 'hello' %>}).should == 'hello'
  end

  it "should render ERB templates using the binding of the object" do
    @uses_templates.erb(%{<%= @x %> <%= @y %>}).should == '2 3'
  end
end

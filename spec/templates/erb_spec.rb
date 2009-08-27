require 'ronin/templates/erb'

require 'spec_helper'
require 'templates/classes/example_erb'

describe Templates::Erb do
  before(:all) do
    @uses_erb= ExampleErb.new
    @uses_erb.x = 2
    @uses_erb.y = 3
  end

  it "should render inline ERB templates" do
    @uses_erb.erb(%{<%= 'hello' %>}).should == 'hello'
  end

  it "should render ERB templates using the binding of the object" do
    @uses_erb.erb(%{<%= @x %> <%= @y %>}).should == '2 3'
  end
end

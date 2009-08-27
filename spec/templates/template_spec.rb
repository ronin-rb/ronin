require 'ronin/templates/template'

require 'spec_helper'
require 'templates/classes/example_template'
require 'templates/helpers/static'

describe Templates::Template do
  before(:all) do
    @example_template = File.join(STATIC_TEMPLATE_DIR,'example_template.txt')
    @relative_template = File.join(STATIC_TEMPLATE_DIR,'_relative_template.txt')
  end

  before(:each) do
    @template = ExampleTemplate.new
  end

  it "should return the result of the block when entering a template" do
    @template.enter_example_template { |path|
      'result'
    }.should == 'result'
  end

  it "should be able to find templates relative to the current one" do
    @template.enter_example_template do |path|
      path.should == @example_template
    end
  end

  it "should be able to find static templates" do
    @template.enter_relative_template do |path|
      path.should == @relative_template
    end
  end

  it "should raise a RuntimeError when entering an unknown template" do
    lambda {
      @template.enter_missing_template do |path|
      end
    }.should raise_error(RuntimeError)
  end
end

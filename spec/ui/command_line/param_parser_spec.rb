require 'ronin/ui/command_line/param_parser'

require 'spec_helper'
require 'ui/command_line/helpers/example_command'

describe UI::CommandLine::ParamParser do
  before(:all) do
    @command = ExampleCommand.new('example')
  end

  it "should parse params of the form 'name'" do
    @command.param_parser('var')

    @command.params.has_key?(:var).should == true
    @command.params[:var].should be_nil
  end

  it "should parse params of the form 'name=value'" do
    @command.param_parser('var1=test')
    @command.params[:var1].should == 'test'
  end

  it "should parse params which have numeric values" do
    @command.param_parser('var2=100')
    @command.params[:var2].should == 100
  end

  it "should parse params with hexadecimal values" do
    @command.param_parser('var3=0x2a')
    @command.params[:var3].should == 0x2a
  end

  it "should parse params with URI values" do
    url = 'http://example.com/'

    @command.param_parser("var4=#{url}")
    @command.params[:var4].should == URI(url)
  end

  it "should parse params with true boolean values" do
    @command.param_parser('var5=true')
    @command.params[:var5].should == true
  end

  it "should parse params with false boolean values" do
    @command.param_parser('var6=false')
    @command.params[:var6].should == false
  end
end

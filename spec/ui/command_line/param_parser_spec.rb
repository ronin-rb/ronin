require 'ronin/ui/command_line/param_parser'

require 'spec_helper'

describe UI::CommandLine::ParamParser do
  before(:all) do
    class ExampleCommand

      include UI::CommandLine::ParamParser

    end

    @command = ExampleCommand.new
  end

  it "should provide a params Hash" do
    @command.params.should_not be_nil
  end

  it "should parse params of the form 'name'" do
    @command.parse_param('var')

    @command.params.has_key?(:var).should == true
    @command.params[:var].should be_nil
  end

  it "should parse params of the form 'name=value'" do
    @command.parse_param('var1=test')
    @command.params[:var1].should == 'test'
  end

  it "should parse params which have numeric values" do
    @command.parse_param('var2=100')
    @command.params[:var2].should == 100
  end

  it "should parse params with hexadecimal values" do
    @command.parse_param('var3=0x2a')
    @command.params[:var3].should == 0x2a
  end

  it "should parse params with URI values" do
    url = 'http://example.com/'

    @command.parse_param("var4=#{url}")
    @command.params[:var4].should == URI(url)
  end

  it "should parse params with true boolean values" do
    @command.parse_param('var5=true')
    @command.params[:var5].should == true
  end

  it "should parse params with false boolean values" do
    @command.parse_param('var6=false')
    @command.params[:var6].should == false
  end
end

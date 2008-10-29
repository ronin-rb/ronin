require 'ronin/code/token'

require 'spec_helper'

describe Code::Token do
  before(:all) do
    @token = Code::Token.new('test')
  end

  it "should emit itself" do
    @token.emit.should == [@token]
  end
end

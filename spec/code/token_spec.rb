require 'ronin/code/token'

require 'spec_helper'

include Code

describe Code::Token do
  before(:all) do
    @token = Token.new('test')
  end

  it "should emit itself" do
    @token.emit.should == [@token]
  end
end

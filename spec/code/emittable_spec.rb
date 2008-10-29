require 'ronin/code/emittable'

require 'spec_helper'

include Code

describe Code::Emittable do
  include Emittable

  it "should emit an empty Array" do
    emit.should == []
  end

  it "should emit a token" do
    emit_token('test').should == [Token.new('test')]
  end

  it "should emit values" do
    values = [1,2,Token.new('test'),'test']

    emit_values(values).should == values
  end
end

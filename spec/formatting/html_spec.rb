require 'spec_helper'

require 'ronin/formatting/html'

describe String do
  before(:all) do
    @raw_text = "x > y && y != 0"
    @html_encoded_text = "x &gt; y &amp;&amp; y != 0"

    @raw_html = "<p>Hello <strong>dude</strong></p>"
    @stripped_text = "Hello dude"
  end

  it "should provide String#html_encode" do
    @raw_text.respond_to?('html_encode').should == true
  end

  it "String#html_encode should HTML encode itself" do
    @raw_text.html_encode.should == @html_encoded_text
  end

  it "should provide String#html_decode" do
    @raw_text.respond_to?('html_decode').should == true
  end

  it "String#html_decode should HTML decode itself" do
    @html_encoded_text.html_decode.should == @raw_text
  end

  it "should provide String#strip_html" do
    @raw_text.respond_to?('strip_html').should == true
  end

  it "String#strip_html should strip any HTML from itself" do
    @raw_html.strip_html.should == @stripped_text
  end
end

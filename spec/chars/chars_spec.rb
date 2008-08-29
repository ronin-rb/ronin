require 'ronin/chars/chars'

describe Ronin do
  describe Chars do
    before(:all) do
      @numeric_string = Chars.numeric.random_string(10)
      @octal_string = Chars.octal.random_string(10)
      @uppercase_hex_string = Chars.uppercase_hexadecimal.random_string(10)
      @lowercase_hex_string = Chars.lowercase_hexadecimal.random_string(10)
      @hex_string = Chars.hexadecimal.random_string(10)
      @uppercase_alpha_string = Chars.uppercase_alpha.random_string(10)
      @lowercase_alpha_string = Chars.lowercase_alpha.random_string(10)
      @alpha_string = Chars.alpha.random_string(10)
      @alpha_numeric = Chars.alpha_numeric.random_string(10)
      @space_string = Chars.space.random_string(10)
      @punctuation_string = Chars.punctuation.random_string(10)
      @symbols_string = Chars.symbols.random_string(10)
      @control_string = Chars.control.random_string(10)
      @ascii_string = Chars.ascii.random_string(10)
      @all_string = Chars.all.random_string(10)
    end

    it "should provide a numeric CharSet" do
      (@numeric_string =~ /[0-9]{10}/).should_not be_nil
    end

    it "should provide an octal CharSet" do
      (@octal_string =~ /[0-7]{10}/).should_not be_nil
    end

    it "should provide an upper-case hexadecimal CharSet" do
      (@uppercase_hex_string =~ /[0-9A-F]{10}/).should_not be_nil
    end

    it "should provide a lower-case hexadecimal CharSet" do
      (@lowercase_hex_string =~ /[0-9a-f]{10}/).should_not be_nil
    end

    it "should provide a hexadecimal CharSet" do
      (@hex_string =~ /[0-9A-Fa-f]{10}/).should_not be_nil
    end

    it "should provide an upper-case alpha CharSet" do
      (@uppercase_alpha_string =~ /[A-Z]{10}/).should_not be_nil
    end

    it "should provide a lower-case alpha CharSet" do
      (@lowercase_alpha_string =~ /[a-z]{10}/).should_not be_nil
    end

    it "should provide an alpha CharSet" do
      (@alpha_string =~ /[A-Za-z]{10}/).should_not be_nil
    end

    it "should provide an alpha-numeric CharSet" do
      (@alpha_numeric_string =~ /[A-Za-z0-9]{10}/).should_not be_nil
    end

    it "should provide a space CharSet" do
      (@space_string =~ /[ \f\n\r\t\v]{10}/).should_not be_nil
    end

    it "should provide a punctuation CharSet" do
      (@punctuation_string =~ /[ \'\"\`\,\;\:\~\-\(\)\[\]\{\}\.\?\!]{10}/).should_not be_nil
    end

    it "should provide a symbols CharSet" do
      #(@symbols_string =~ /[\@\#\$\%\^\&\*\_\+\=\|\\\<\>\/]{10}/).should_not be_nil
    end

    it "should provide a control CharSet" do
    end

    it "should provide an ascii CharSet" do
    end

    it "should provide an 'all' CharSet" do
    end
  end
end

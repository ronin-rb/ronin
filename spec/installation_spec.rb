require 'spec_helper'
require 'ronin/installation'

describe Installation do
  it "should load the gemspec for the 'ronin' library" do
    subject.gems['ronin'].should_not be_nil
  end

  it "should find the installation path of the 'ronin' library" do
    subject.paths['ronin'].should_not be_nil
  end

  it "should provide the names of the installed Ronin libraries" do
    subject.libraries.should include('ronin')
  end

  describe "each_file" do
    let(:directory) { 'lib/ronin/ui/cli/commands' }
    let(:expected) {
      %w[
        campaigns.rb
        console.rb
        creds.rb
        database.rb
        emails.rb
        exec.rb
        help.rb
        hosts.rb
        ips.rb
        repos.rb
        urls.rb
      ]
    }

    it "should enumerate over the files within a certain directory" do
      subject.each_file(directory).to_a.should =~ expected
    end

    it "should return an Enumerator when no block is given" do
      subject.each_file(directory).all? { |file|
        expected.include?(file)
      }.should == true
    end
  end
end

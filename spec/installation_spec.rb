require 'spec_helper'
require 'ronin/installation'

describe Installation do
  it "should load the gemspec for the 'ronin' library" do
    subject.gems['ronin'].should_not be_nil
  end

  it "should provide the names of the installed Ronin libraries" do
    subject.libraries.should include('ronin')
  end

  describe "each_file" do
    let(:directory) { 'lib/ronin/ui/cli/commands' }
    let(:pattern) { File.join(directory,'*.rb') }
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
      ].map { |name| File.join(directory,name) }
    }

    it "should enumerate over the files which match a glob pattern" do
      subject.each_file(pattern).to_a.should =~ expected
    end

    it "should return an Enumerator when no block is given" do
      subject.each_file(pattern).all? { |file|
        expected.include?(file)
      }.should == true
    end
  end

  describe "each_file_in" do
    let(:directory) { 'lib/ronin/ui/cli/commands' }
    let(:ext) { :rb }
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

    it "should enumerate over the files which match a glob pattern" do
      subject.each_file_in(directory,ext).to_a.should =~ expected
    end

    it "should return an Enumerator when no block is given" do
      subject.each_file_in(directory,ext).all? { |file|
        expected.include?(file)
      }.should == true
    end
  end
end

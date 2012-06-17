require 'spec_helper'
require 'ronin/installation'

describe Installation do
  it "should load the gemspec for the 'ronin' library" do
    subject.gems['ronin'].should_not be_nil
  end

  it "should provide the names of the installed Ronin libraries" do
    subject.libraries.should include('ronin')
  end

  let(:directory) { 'lib/ronin/ui/cli/commands/'                }
  let(:pattern)   { File.join(directory,'**','*.rb')            }
  let(:paths)     { Dir[pattern]                                }
  let(:files)     { paths.map { |path| path.sub(directory,'') } }

  describe "each_file" do
    it "should enumerate over the files which match a glob pattern" do
      subject.each_file(pattern).to_a.should =~ paths
    end

    it "should return an Enumerator when no block is given" do
      subject.each_file(pattern).should respond_to(:each)
    end
  end

  describe "each_file_in" do
    let(:ext)      { :rb }
    let(:expected) { files }

    it "should enumerate over the files which match a glob pattern" do
      subject.each_file_in(directory,ext).to_a.should =~ expected
    end

    it "should return an Enumerator when no block is given" do
      subject.each_file_in(directory,ext).should respond_to(:each)
    end
  end
end

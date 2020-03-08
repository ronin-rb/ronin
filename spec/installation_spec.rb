require 'spec_helper'
require 'ronin/installation'

describe Installation do
  it "should load the gemspec for the 'ronin' library" do
    expect(subject.gems['ronin']).not_to be_nil
  end

  it "should provide the names of the installed Ronin libraries" do
    expect(subject.libraries).to include('ronin')
  end

  let(:directory) { 'lib/ronin/ui/cli/commands/'                }
  let(:pattern)   { File.join(directory,'**','*.rb')            }
  let(:paths)     { Dir[pattern]                                }
  let(:files)     { paths.map { |path| path.sub(directory,'') } }

  describe "each_file" do
    it "should enumerate over the files which match a glob pattern" do
      expect(subject.each_file(pattern).to_a).to match_array(paths)
    end

    it "should return an Enumerator when no block is given" do
      expect(subject.each_file(pattern)).to respond_to(:each)
    end
  end

  describe "each_file_in" do
    let(:ext)      { :rb }
    let(:expected) { files }

    it "should enumerate over the files which match a glob pattern" do
      expect(subject.each_file_in(directory,ext).to_a).to match_array(expected)
    end

    it "should return an Enumerator when no block is given" do
      expect(subject.each_file_in(directory,ext)).to respond_to(:each)
    end
  end
end

require 'rspec'

RSpec.shared_examples_for "man_page" do
  describe "man_page" do
    subject { described_class }

    it "must define a man page" do
      expect(subject.man_page).to_not be(nil)
    end

    it "must map to a markdown man page" do
      man_page_md_path = File.join(subject.man_dir,"#{subject.man_page}.md")

      expect(File.file?(man_page_md_path)).to be(true)
    end
  end
end

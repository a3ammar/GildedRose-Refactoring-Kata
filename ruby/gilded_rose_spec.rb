require File.join(File.dirname(__FILE__), "gilded_rose")

describe GildedRose do
  describe "#update_quality" do
    let(:items) { [Item.new("Wolf Belt", 1, 1)] }

    subject { described_class.new(items) }

    it "does not change the name" do
      subject.update_quality
      expect(items[0].name).to eq "Wolf Belt"
    end
  end
end

require File.join(File.dirname(__FILE__), "gilded_rose")

describe GildedRose do
  let(:rose) { described_class.new(items) }
  let(:item) { items[0] }

  describe "#update_quality without special item" do
    let(:items) do
      [
        Item.new("+5 Dexterity Vest", 10, 20),
        Item.new("Elixir of the Mongoose", 5, 7)
      ]
    end

    it "doesn't change #name" do
      expect { rose.update_quality }.not_to change { item.name }
    end

    it "changes #quality" do
      expect { rose.update_quality }.to change { item.quality }
    end

    it "changes #quality of all the items" do
      initial_quality = items.map(&:quality)
      rose.update_quality
      after_quality = items.map(&:quality)

      expect(initial_quality).not_to eq(after_quality)
    end

    it "doesn't degrades #quality below 0" do
      100.times { rose.update_quality }

      expect(item.quality).to eq(0)
    end

    context "when Item#sell_in is not zero" do
      it "degrades #quality at a constant rate" do
        rate = item.quality - rose.update_quality[0].quality

        expect { rose.update_quality }.to change { item.quality }.by(rate * -1)
      end
    end

    context "when Item#sell_in is zero" do
      it "degrades #quality twice as fast" do
        rate = item.quality - rose.update_quality[0].quality
        item.sell_in = 0

        expect { rose.update_quality }.to change { item.quality }.by(rate * -2)
      end
    end
  end

  describe "#update_quality with Aged Brie" do
    let(:items) { [Item.new("Aged Brie", 2, 0)] }

    it "improves #quality as #sell_in appraches" do
      initial_quality = item.quality
      rose.update_quality

      expect(item.quality).to be > initial_quality
    end

    it "doesn't improve #quality above 50" do
      100.times { rose.update_quality }

      expect(item.quality).to eq(50)
    end
  end

  describe "#update_quality with Sulfuras, Hand of Ragnaros" do
    let(:items) do
      [
        Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
        Item.new("Sulfuras, Hand of Ragnaros", -1, 80)
      ]
    end

    it "does not change #quality, because it's legendary" do
      initial_quality = items.map(&:quality)
      rose.update_quality
      after_quality = items.map(&:quality)

      expect(initial_quality).to eq(after_quality)
    end

    it "does not change #sell_in, because it's legendary" do
      initial_sell_in = items.map(&:sell_in)
      rose.update_quality
      after_sell_in = items.map(&:sell_in)

      expect(initial_sell_in).to eq(after_sell_in)
    end
  end

  describe "#update_quality with Backstage passes" do
    let(:items) { [Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)] }

    it "improves #quality as #sell_in approaches" do
      initial_quality = item.quality
      rose.update_quality

      expect(item.quality).to be > initial_quality
    end

    context "when #sell_in is 10 days or less" do
      before { items[0].sell_in = 10 }

      it "improves #quality by 2" do
        initial_quality = item.quality
        rose.update_quality

        expect(item.quality - initial_quality).to eq(2)
      end
    end

    context "when #sell_in is 5 days or less" do
      before { items[0].sell_in = 5 }

      it "improves #quality by 3" do
        initial_quality = item.quality
        rose.update_quality

        expect(item.quality - initial_quality).to eq(3)
      end
    end

    context "when passed #sell_in date" do
      before { items[0].sell_in = 0 }

      it "drops #quality to zero" do
        rose.update_quality
        expect(item.quality).to eq(0)
      end
    end
  end

  describe "#update_quality with Conjured Mana Cake" do
    let(:items) do
      [
        Item.new("Conjured Mana Cake", 3, 6),
        Item.new("Mana Cake", 3, 6)
      ]
    end

    it "degrades the quality twice as fast" do
      conjured = items[0].quality
      regular  = items[1].quality
      rose.update_quality
      conjured_rate = conjured - items[0].quality
      regular_rate  = regular  - items[1].quality

      expect(conjured_rate).to eq(regular_rate * 2)
    end
  end
end

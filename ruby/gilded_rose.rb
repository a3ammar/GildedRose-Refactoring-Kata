class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next unless item.quality.between?(0, 50)

      case item.name
      when "Aged Brie"
        rate = 1
      when "Backstage passes to a TAFKAL80ETC concert"
        rate = 1
        rate += 1 if item.sell_in <= 10
        rate += 1 if item.sell_in <= 5
        rate = -item.quality if item.sell_in <= 0
      else
        rate = -1
      end

      rate *= 2 if item.sell_in <= 0
      item.quality += rate
      item.quality = 0 if item.quality.negative?
      item.quality = item.quality % 50
      item.sell_in -= 1
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

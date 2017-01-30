class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if item.name == "Sulfuras, Hand of Ragnaros"

      rate = Rate.new(item).calculate
      item.sell_in -= 1
      item.quality += rate

      # Ensures quality stays between 0 and 50
      item.quality = [item.quality, 0].max
      item.quality = [item.quality, 50].min
    end
  end
end

class Rate < SimpleDelegator
  def initialize(item)
    @rate = -1
    super(item)
  end

  def calculate
    case name
    when "Aged Brie"
      @rate = 1
    when "Backstage passes to a TAFKAL80ETC concert"
      @rate = 1
      @rate += 1 if sell_in <= 10
      @rate += 1 if sell_in <= 5
      @rate = -1 * quality if sell_in <= 0
    when /\AConjured.*/
      @rate *= 2
      puts "HI #{@rate}"
    end

    @rate *= 2 if sell_in <= 0
    @rate
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

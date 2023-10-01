require "./item.cr"

module FindingMaya
  class Inventory
    def initialize
      @items = Array(Item).new
    end

    def add_item(name : String)
      @items << Item.new(name)
    end

    def items
      @items
    end

    def remove_item(name : String)
      @items.delete_if { |item| item.name == name }
    end
  end
end

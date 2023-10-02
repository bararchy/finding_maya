module FindingMaya
  class Item
    enum ItemClass
      Weapon
      Armor
      Consumable
      Misc
    end

    getter name : String
    getter description : String
    getter item_class : ItemClass
    getter texture : Raylib::Texture2D

    property x : Int32
    property y : Int32
    property equipped : Bool = false

    def initialize(@name : String, @item_class : ItemClass, @texture : Raylib::Texture2D, @description : String = "", @x : Int32 = 0, @y : Int32 = 0)
    end

    def draw
      Raylib.draw_texture(@texture, @x, @y, Raylib::WHITE)
    end
  end
end

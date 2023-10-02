module FindingMaya
  class Entity
    # This class respresents an Entity in the game. It is a base class for all
    # other entities.

    # Each entity has a name, a description, and a list of actions that can be
    # performed on it.
    # It also has an X and Y coordinate, which are used to determine where it
    # is in the game world.

    getter name : String
    getter description : String
    property x : Int32
    property y : Int32
    getter? collusion : Bool

    # Set the texture for the entity
    @texture : Raylib::Texture2D

    # rectangle
    getter rectangle : Raylib::Rectangle

    def initialize(@name, @description, @x, @y, @texture, @collusion = true)
      @rectangle = Raylib::Rectangle.new(x: @x, y: @y, width: @texture.width, height: @texture.height)
    end

    def draw
      Raylib.draw_texture(@texture, @x, @y, Raylib::WHITE)
    end

    def update(x : Int32, y : Int32)
      @x = x
      @y = y
      @rectangle.x = x
      @rectangle.y = y
    end
  end
end

module FindingMaya
  abstract class Entity
    # This class respresents an Entity in the game. It is a base class for all
    # other entities.

    # Each entity has a name, a description, and a list of actions that can be
    # performed on it.
    # It also has an X and Y coordinate, which are used to determine where it
    # is in the game world.

    property x : Int32
    property y : Int32
    getter? collision : Bool

    # Set the texture for the entity
    @texture : Raylib::Texture2D

    # rectangle
    getter rectangle : Raylib::Rectangle

    # This property allows to link two entities together
    # Giving us ability to make one entity interact with another
    # For example, a computer that when interacted with, opens a door.
    property linked_entity : Entity? = nil

    def initialize(@player : Player, @x, @y, @collision = true)
      @texture = load_texture
      @rectangle = Raylib::Rectangle.new(x: @x, y: @y, width: @texture.width, height: @texture.height)
    end

    # this method is used by the level to draw the entity
    abstract def draw

    # This method is called when the player interacts with the entity.
    # It should be overridden by subclasses.
    abstract def interact

    abstract def load_texture : Raylib::Texture2D

    # This method is called when the player looks at the entity.
    abstract def name : String
    # This method is called when the player looks at the entity.
    abstract def description : String

    def action
      # For relevant entities, this method is called when the entity supports
      # an action.
      # For example, a door which can be opened.
      # Or a light switch which can be turned on.
    end

    def update(x : Int32, y : Int32)
      @x = x
      @y = y
      @rectangle.x = x
      @rectangle.y = y
    end
  end
end

require "./inventory.cr"

module FindingMaya
  class Player
    # main information
    getter name : String

    # stats
    property agility : Int32 = 0
    property strength : Int32 = 0
    property intelligence : Int32 = 0
    property charisma : Int32 = 0

    # inventory
    getter inventory : Inventory = Inventory.new

    # cash
    property cash : Int32 = 0

    # position
    property x : Int32 = 0
    property y : Int32 = 0

    property last_direction : String = "right"

    getter? collision : Bool = true

    # rectangle
    getter rectangle : Raylib::Rectangle

    def initialize(@name : String)
      @player_texture_left = Raylib.load_texture("assets/images/player/player_left.png")
      @player_texture_right = Raylib.load_texture("assets/images/player/player_right.png")
      @player_texture_idle = Raylib.load_texture("assets/images/player/player_idle.png")
      @frame_counter = 0
      @rectangle = Raylib::Rectangle.new(x: @x, y: @y, width: @player_texture_idle.width, height: @player_texture_idle.height)
    end

    def move_by(x : Int32 = 0, y : Int32 = 0)
      @x += x
      @y += y
      @rectangle.x = @x
      @rectangle.y = @y
    end

    def move_to(x : Int32 = 0, y : Int32 = 0)
      @x = x
      @y = y
      @rectangle.x = @x
      @rectangle.y = @y
    end

    def send(stat : String) : Int32
      case stat
      when "agility"
        agility
      when "strength"
        strength
      when "intelligence"
        intelligence
      when "charisma"
        charisma
      else
        raise "Invalid stat"
      end
    end

    def draw
      # draw the player on the screen
      # the position property is an instance of the Position class
      # cycle through the frames of the player's animation to show walking based on the player's position
      # the player_texture property is a Raylib::Texture2D
      case @last_direction
      when "left"
        player_texture = @player_texture_left
        num_of_frames = 8
      when "right"
        player_texture = @player_texture_right
        num_of_frames = 8
      else # idle
        player_texture = @player_texture_idle
        num_of_frames = 5
      end

      frame_width = player_texture.width / num_of_frames
      frame_height = player_texture.height
      frame = (Raylib.get_time * 8).to_i % num_of_frames
      # Use the relevant texture based on the last direction the player was moving

      Raylib.draw_texture_rec(player_texture, Raylib::Rectangle.new(x: frame * frame_width, y: 0, width: frame_width, height: frame_height), Raylib::Vector2.new(x: @x, y: @y), Raylib::WHITE)
      # Make sure to cycle through the frames of the player's animation to show walking
      @frame_counter += 1
      if @frame_counter > num_of_frames
        @frame_counter = 0
      end
    end
  end
end

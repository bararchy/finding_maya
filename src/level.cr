require "./player.cr"

# require "./npc.cr"
# require "./item.cr"

module FindingMaya
  class Level
    # this class will implement the generic logic needed for all levels
    alias Element = Entity # NPC
    PLAYER_WALK_SPEED    = 5
    INTERACTION_DISTANCE = 10

    getter player : Player

    getter all_objects : Array(Element)

    @max_x : Int32
    @max_y : Int32
    @min_x : Int32
    @min_y : Int32

    def initialize(
      @background : Raylib::Texture2D,
      @player : Player,
      @items : Array(Item) = Array(Item).new,
      @entities : Array(Entity) = Array(Entity).new
    )
      # lets get the size of the background and set @max_x and @max_y
      # We need to get the size of the background to determine the edge of the map
      # We need to take in mind that the background is being moved to the center of the screen
      # So the max_x and max_y will be the size of the background minus the size of the screen
      # divided by 2
      # Calculate center of the screen
      center_x = Raylib.get_screen_width / 2
      center_y = Raylib.get_screen_height / 2

      # Calculate min_x and min_y based on center and background size
      @min_x = (center_x - (@background.width / 2)).to_i
      @min_y = (center_y - (@background.height / 2)).to_i

      # Calculate max_x and max_y based on min values and background size
      @max_x = (@min_x + @background.width).to_i
      @max_y = (@min_y + @background.height).to_i

      # let's position the player in the center of the screen
      @player.x = (@max_x / 2).to_i
      @player.y = (@max_y / 2).to_i

      # populate the array with all the elements
      @all_objects = Array(Element).new
      @entities.each do |entity|
        @all_objects << entity
      end
    end

    def play
      # This is the level game loop, it will run until the player finishes the level or exiting or losing.
      loop do
        Raylib.begin_drawing
        draw
        Raylib.end_drawing
        move_player do
          Raylib.begin_drawing
          draw
          Raylib.end_drawing
        end
        # We use the space key to interact with the elements
        if Raylib.key_pressed?(Raylib::KeyboardKey::Space)
          interact
        end
        break if Raylib.key_pressed?(Raylib::KeyboardKey::Escape)
        break if Raylib.close_window?
      end
    end

    def interact
      # This method will check if the player is colliding with an element
      # If the player is colliding with an element, it will call the interact method of the element
      # If the player is not colliding with an element, it will do nothing
      if element = colliding_with
        element.interact
      end
    end

    def colliding_with : Element?
      # This method will check all the elements in the level and return the first element that is colliding with the player
      # It will be used to check for interactions, like talking to an NPC or picking up an item.
      # Note that we do not allow the player to acctually collide with an element is shown in the move_player method
      # So we will need to check the surrounding elements to see if the player is colliding with them
      # We will check 5 pixels in each direction
      # We will check the @all_objects array and return the first element that is colliding with the player
      # If no element is colliding with the player we will return nil

      # First, let's see if the player will even be colliding with an element, the "area" will be INTERACTION_DISTANCE
      @all_objects.each do |element|
        # Now we need to move the player to the future position
        old_x = @player.x
        old_y = @player.y
        # we need to move the player 4 times for each element to check for the collusion
        # we will move the player INTERACTION_DISTANCE pixels in each direction
        # we will move the player up
        @player.move_by(y: -INTERACTION_DISTANCE)
        if Raylib.check_collision_recs?(@player.rectangle, element.rectangle)
          # Now we restore the player position
          @player.move_to(x: old_x, y: old_y)
          return element
        end
        # we will move the player down
        @player.move_by(y: INTERACTION_DISTANCE)
        if Raylib.check_collision_recs?(@player.rectangle, element.rectangle)
          # Now we restore the player position
          @player.move_to(x: old_x, y: old_y)
          return element
        end
        # we will move the player left
        @player.move_by(x: -INTERACTION_DISTANCE)
        if Raylib.check_collision_recs?(@player.rectangle, element.rectangle)
          # Now we restore the player position
          @player.move_to(x: old_x, y: old_y)
          return element
        end
        # we will move the player right
        @player.move_by(x: INTERACTION_DISTANCE)
        if Raylib.check_collision_recs?(@player.rectangle, element.rectangle)
          # Now we restore the player position
          @player.move_to(x: old_x, y: old_y)
          return element
        end
        # Now we restore the player position
        @player.move_to(x: old_x, y: old_y)
      end

      # If we get here, it means that the player is not colliding with any element
      # So we return nil
      nil
    end

    def colliding?(x : Int32 = 0, y : Int32 = 0) : Bool
      # this method checks that the player is not colliding with an element
      # it will return true if the player is colliding with an element
      # it will return false if the player is not colliding with an element
      # First we update the player position to the future position
      old_x = @player.x
      old_y = @player.y
      @player.move_by(x: x, y: y)
      will_collide = @all_objects.any? { |element| Raylib.check_collision_recs?(@player.rectangle, element.rectangle) }
      # Now we restore the player position
      @player.move_to(x: old_x, y: old_y)
      will_collide
    end

    def move_player
      # move the player in the given direction
      # unless the player is at the edge of the map
      # use the max_x and max_y properties to determine the edge of the map
      # the position property is an instance of the Position class
      while Raylib.key_down?(Raylib::KeyboardKey::Up)
        unless (player.y - PLAYER_WALK_SPEED <= @min_y) || colliding?(y: -PLAYER_WALK_SPEED)
          player.move_by(y: -PLAYER_WALK_SPEED)
        end
        player.last_direction = "right"
        yield
      end
      while Raylib.key_down?(Raylib::KeyboardKey::Down)
        unless (player.y + PLAYER_WALK_SPEED >= @max_y) || colliding?(y: PLAYER_WALK_SPEED)
          player.move_by(y: PLAYER_WALK_SPEED)
        end
        player.last_direction = "right"
        yield
      end
      while Raylib.key_down?(Raylib::KeyboardKey::Left)
        unless player.x - PLAYER_WALK_SPEED <= @min_x || colliding?(x: -PLAYER_WALK_SPEED)
          player.move_by(x: -PLAYER_WALK_SPEED)
        end
        player.last_direction = "left"
        yield
      end
      while Raylib.key_down?(Raylib::KeyboardKey::Right)
        unless player.x + PLAYER_WALK_SPEED >= @max_x || colliding?(x: PLAYER_WALK_SPEED)
          player.move_by(x: PLAYER_WALK_SPEED)
        end
        player.last_direction = "right"
        yield
      end
      player.last_direction = "idle"
    end

    def draw
      # This method will draw the level
      Raylib.clear_background(Raylib::BLACK)
      # Draw the background in the middle of the scrren
      Raylib.draw_texture(@background, @min_x, @min_y, Raylib::WHITE)

      @all_objects.each do |element|
        element.draw
      end
      player.draw
    end
  end
end

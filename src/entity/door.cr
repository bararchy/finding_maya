module FindingMaya
  class Door < Entity
    enum State
      Opened
      Closed
    end

    getter state : State = State::Closed
    @opened_texture : Raylib::Texture2D = Raylib.load_texture(Path["assets", "images", "metal_opened_door.png"].to_native.to_s)
    @closed_texture : Raylib::Texture2D = Raylib.load_texture(Path["assets", "images", "metal_closed_door.png"].to_native.to_s)

    def interact
      # Just print a message giving the @description of the Door and @name
      loop do
        Raylib.begin_drawing
        Raylib.draw_text(name, 10, 10, 20, Raylib::WHITE)
        Raylib.draw_text(description, 10, 40, 20, Raylib::WHITE)
        if @state == State::Opened
          Raylib.draw_text("The door is opened!. you can now move forward!", 10, 100, 20, Raylib::GREEN)
        else
          Raylib.draw_text("The door is locked. You need to find a way to open it.", 10, 100, 20, Raylib::RED)
        end
        Raylib.draw_text("Press Enter to continue", 10, 130, 20, Raylib::WHITE)

        Raylib.end_drawing
        break if Raylib.key_pressed?(Raylib::KeyboardKey::Enter)
      end
    end

    def load_texture : Raylib::Texture2D
      Raylib.load_texture(Path["assets", "images", "metal_closed_door.png"].to_native.to_s)
    end

    def name : String
      "A door"
    end

    def description : String
      if @state == State::Opened
        "A large metal door, it's open."
      else
        "A large metal door, it's locked."
      end
    end

    def action
      @state = State::Opened
      @collision = false
    end

    def draw
      if @state == State::Opened
        Raylib.draw_texture(@opened_texture, @x, @y, Raylib::WHITE)
      else
        Raylib.draw_texture(@closed_texture, @x, @y, Raylib::WHITE)
      end
    end
  end
end

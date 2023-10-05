module FindingMaya
  class Computer < Entity
    def interact
      # Just print a message giving the @description of the computer and @name
      loop do
        Raylib.begin_drawing
        Raylib.draw_text(name, 10, 10, 20, Raylib::WHITE)
        Raylib.draw_text(description, 10, 40, 20, Raylib::WHITE)
        if @player.intelligence > 0
          Raylib.draw_text("You manage to find the program which operates the door and you open it", 10, 70, 20, Raylib::GREEN)
          if @linked_entity
            @linked_entity.try &.action
          end
        else
          Raylib.draw_text("You don't know how to use this.", 10, 70, 20, Raylib::RED)
        end
        Raylib.draw_text("Press Enter to continue", 10, 100, 20, Raylib::WHITE)
        Raylib.end_drawing
        break if Raylib.key_pressed?(Raylib::KeyboardKey::Enter)
      end
    end

    def load_texture : Raylib::Texture2D
      Raylib.load_texture(Path["assets", "images", "computer_terminal.png"].to_native.to_s)
    end

    def name : String
      "Computer Terminal"
    end

    def description : String
      "A computer terminal with a blinking cursor. it seems to be waiting for input."
    end

    def draw
      # If player has higher than 0 intelligence, draw the computer normally
      # otherwise draw it grayed out
      if @player.intelligence > 0
        Raylib.draw_texture(@texture, @x, @y, Raylib::WHITE)
      else
        Raylib.draw_texture(@texture, @x, @y, Raylib::GRAY)
      end
    end
  end
end

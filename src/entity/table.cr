module FindingMaya
  class Table < Entity
    def interact
      # Just print a message giving the @description of the table and @name
      loop do
        Raylib.begin_drawing
        Raylib.draw_text(name, 10, 10, 20, Raylib::WHITE)
        Raylib.draw_text(description, 10, 40, 20, Raylib::WHITE)
        Raylib.draw_text("(Press Enter to continue)", 10, 70, 20, Raylib::WHITE)
        Raylib.end_drawing
        break if Raylib.key_pressed?(Raylib::KeyboardKey::Enter)
      end
    end

    def load_texture : Raylib::Texture2D
      Raylib.load_texture(Path["assets", "images", "table.png"].to_native.to_s)
    end

    def name : String
      "Table"
    end

    def description : String
      "A table, Nothing special about it, it's a bit dirty, maybe you should clean it"
    end

    def draw
      Raylib.draw_texture(@texture, @x, @y, Raylib::WHITE)
    end
  end
end

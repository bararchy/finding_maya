module FindingMaya
  class Table < Entity
    def interact
      # Just print a message giving the @description of the table and @name
      loop do
        break if Raylib.key_pressed?(Raylib::KeyboardKey::Enter)
        Raylib.begin_drawing
        Raylib.draw_text(@name, 10, 10, 20, Raylib::WHITE)
        Raylib.draw_text(@description, 10, 40, 20, Raylib::WHITE)
        Raylib.end_drawing
      end
    end
  end
end

module FindingMaya
  def self.user_text_input_window(texture : Raylib::Texture2D, text : String, x : Int32, y : Int32, clear_background : Bool = true) : String
    # This method will make a window that will ask the user for a string input
    user_text = ""
    loop do
      Raylib.begin_drawing
      Raylib.clear_background(Raylib::WHITE) if clear_background
      Raylib.draw_texture(texture, x, y, Raylib::WHITE)
      # Draw the text and below it the user text
      Raylib.draw_text(text, x + 10, y + 10, 20, Raylib::WHITE)
      Raylib.draw_text(user_text, x + 10, y + 40, 20, Raylib::WHITE)
      if char = Raylib.get_char_pressed
        unless char.zero?
          user_text += char.chr
        end
      end
      Raylib.end_drawing
      break if Raylib.key_pressed?(Raylib::KeyboardKey::Enter)
      break if Raylib.key_pressed?(Raylib::KeyboardKey::Escape)
      if Raylib.key_pressed?(Raylib::KeyboardKey::Backspace)
        user_text = user_text[0..-2] unless user_text.size == 0
      end
    end
    user_text
  end
end

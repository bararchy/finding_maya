require "./player.cr"

module FindingMaya
  class Game
    SCREEN_WIDTH  = Raylib.get_screen_width
    SCREEN_HEIGHT = Raylib.get_screen_height

    # Menu Constants
    BACKGROUND_IMAGE = "assets/images/big_background.png"
    OPTIONS          = ["New Game", "Exit"]

    enum Scene
      MAIN_MENU
      CHAR_CREATION
      LEVEL1
      LEVEL2
      LEVEL3
      GAME_OVER
    end

    @scene : Scene = Scene::MAIN_MENU
    @selected_option : Int32 = 0
    @player : Player? = nil

    def initialize
      Raylib.init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "Finding Maya")
      Raylib.toggle_fullscreen
      Raylib.set_target_fps(60)
      @background = Raylib.load_texture(BACKGROUND_IMAGE)
    end

    def run
      until Raylib.close_window?
        Raylib.begin_drawing
        case @scene
        when Scene::MAIN_MENU
          main_menu
        when Scene::CHAR_CREATION
          # char_creation
        when Scene::LEVEL1
          # level1
        when Scene::LEVEL2
          # level2
        when Scene::LEVEL3
          # level3
        when Scene::GAME_OVER
          # game_over
        end
        Raylib.end_drawing
      end
    end

    def main_menu
      # Start the Main Menu Class
      # If the user clicks start, change the scene to char creation
      # If the user clicks quit, close the window
      Raylib.draw_texture(@background, 0, 0, Raylib::WHITE)
      Raylib.draw_text("Finding Maya", 300, 100, 100, Raylib::WHITE)
      OPTIONS.each_with_index do |option, index|
        if index == @selected_option
          Raylib.draw_text(option, 300, 300 + (index * 50), 50, Raylib::RED)
        else
          Raylib.draw_text(option, 300, 300 + (index * 50), 50, Raylib::BLACK)
        end
      end
      if Raylib.key_pressed?(Raylib::KeyboardKey::Down) && @selected_option < OPTIONS.size - 1
        @selected_option += 1
      elsif Raylib.key_pressed?(Raylib::KeyboardKey::Up) && @selected_option > 0
        @selected_option -= 1
      elsif Raylib.key_pressed?(Raylib::KeyboardKey::Enter)
        case @selected_option
        when 0
          # Start the game and go to charcter creation
          char_creation
        when 1
          # Quit the game
          stop
        end
      end
    end

    def char_creation
      # Create a new player class
      # Initialize a new Player instance with default stats

      # Define stat points
      points_to_allocate = 2

      # Create a buffer to hold the entered name
      buffer = Bytes.new(256)

      dialog_width = 300
      dialog_height = 150

      input_box_bounds = Raylib::Rectangle.new(
        x: SCREEN_WIDTH / 2,
        y: SCREEN_HEIGHT / 2,
        width: dialog_width,
        height: dialog_height
      )
      # Show the input box
      loop do
        Raylib.begin_drawing
        Raylib.clear_background(Raylib::WHITE)
        Raylib.draw_texture(@background, 0, 0, Raylib::WHITE)
        Raygui.text_input_box(input_box_bounds, "Enter Your Name:", "", "Accept\x00Cancel\x00", buffer.to_unsafe, 256, nil)
        Raylib.end_drawing
        break if Raylib.key_pressed?(Raylib::KeyboardKey::Enter)
        if Raylib.close_window?
          return
        end
      end
      player = Player.new(String.new(buffer))

      done = false
      until Raylib.close_window?
        Raylib.begin_drawing
        Raylib.clear_background(Raylib::WHITE)
        Raylib.draw_texture(@background, 0, 0, Raylib::WHITE)

        # Display instructions
        Raylib.draw_text("Allocate Points", 300, 100, 30, Raylib::BLACK)
        Raylib.draw_text("Name: #{player.name}", 300, 150, 20, Raylib::BLACK)

        # Display stat points and values
        Raylib.draw_text("Agility: #{player.agility}", 300, 200, 20, Raylib::BLACK)
        Raylib.draw_text("Strength: #{player.strength}", 300, 250, 20, Raylib::BLACK)
        Raylib.draw_text("Intelligence: #{player.intelligence}", 300, 300, 20, Raylib::BLACK)
        Raylib.draw_text("Charisma: #{player.charisma}", 300, 350, 20, Raylib::BLACK)

        # Display available stat points
        Raylib.draw_text("Points Remaining: #{points_to_allocate}", 300, 400, 20, Raylib::BLACK)

        # Allow player to allocate points
        if Raylib.key_pressed?(Raylib::KeyboardKey::Down) && points_to_allocate > 0
          case @selected_option
          when 0
            player.agility += 1
          when 1
            player.strength += 1
          when 2
            player.intelligence += 1
          when 3
            player.charisma += 1
          end
          points_to_allocate -= 1
        elsif Raylib.key_pressed?(Raylib::KeyboardKey::Up)
          case @selected_option
          when 0
            if player.agility > 0
              player.agility -= 1
              points_to_allocate += 1
            end
          when 1
            if player.strength > 0
              player.strength -= 1
              points_to_allocate += 1
            end
          when 2
            if player.intelligence > 0
              player.intelligence -= 1
              points_to_allocate += 1
            end
          when 3
            if player.charisma > 0
              player.charisma -= 1
              points_to_allocate += 1
            end
          end
        end

        # Handle input for navigation
        if Raylib.key_pressed?(Raylib::KeyboardKey::Down) && @selected_option < 3
          @selected_option += 1
        elsif Raylib.key_pressed?(Raylib::KeyboardKey::Up) && @selected_option > 0
          @selected_option -= 1
        elsif Raylib.key_pressed?(Raylib::KeyboardKey::Enter)
          case @selected_option
          when 4
            # Save player and proceed to the next scene (e.g., level 1)
            # You'll need to implement this part
            puts "Player Created! Proceeding to Level 1..."
            break
          when 5
            # Go back to the main menu
            @scene = Scene::MAIN_MENU
            break
          end
        end

        Raylib.end_drawing
      end
      @player = player
    end

    def stop
      Raylib.unload_texture(@background)
      Raylib.close_window
    end
  end
end

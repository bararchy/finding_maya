require "./entity.cr"
require "./entity/*"
require "./player.cr"
require "./level.cr"

module FindingMaya
  class Game
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
    @player : Player? = nil

    def initialize
      Raylib.init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "Finding Maya")
      Raylib.toggle_fullscreen
      Raylib.set_target_fps(60)
      @background = Raylib.load_texture(BACKGROUND_IMAGE)
    end

    def run
      loop do
        break if Raylib.close_window?
        break if Raylib.key_pressed?(Raylib::KeyboardKey::Escape)
        case @scene
        when Scene::MAIN_MENU
          main_menu
        when Scene::CHAR_CREATION
          char_creation
        when Scene::LEVEL1
          level1
        when Scene::LEVEL2
          # level2
        when Scene::LEVEL3
          # level3
        when Scene::GAME_OVER
          # game_over
        end
      end
      stop
    end

    def main_menu
      selected_option = 0

      loop do
        Raylib.begin_drawing
        if Raylib.close_window? || Raylib.key_pressed?(Raylib::KeyboardKey::Escape)
          stop
          break
        end

        # Start the Main Menu Class
        # If the user clicks start, change the scene to char creation
        # If the user clicks quit, close the window
        Raylib.draw_texture(@background, 0, 0, Raylib::WHITE)
        Raylib.draw_text("Finding Maya", 300, 100, 100, Raylib::WHITE)
        OPTIONS.each_with_index do |option, index|
          if index == selected_option
            Raylib.draw_text(option, 300, 300 + (index * 50), 50, Raylib::RED)
          else
            Raylib.draw_text(option, 300, 300 + (index * 50), 50, Raylib::WHITE)
          end
        end
        if Raylib.key_pressed?(Raylib::KeyboardKey::Down) && selected_option < OPTIONS.size - 1
          selected_option += 1
        elsif Raylib.key_pressed?(Raylib::KeyboardKey::Up) && selected_option > 0
          selected_option -= 1
        elsif Raylib.key_pressed?(Raylib::KeyboardKey::Enter)
          case selected_option
          when 0
            # Start the game and go to charcter creation
            char_creation
            break
          when 1
            # Quit the game
            stop
            break
          end
        end
        Raylib.end_drawing
      end
    end

    def char_creation
      # Create a new player class
      # Initialize a new Player instance with default stats

      # Define stat points
      points_to_allocate = 2

      # Create a buffer to hold the entered name
      buffer = Bytes.new(256)

      dialog_width = 600
      dialog_height = 300

      input_box_bounds = Raylib::Rectangle.new(
        x: SCREEN_WIDTH / 2,
        y: SCREEN_HEIGHT / 2,
        width: dialog_width,
        height: dialog_height
      )
      # Show the input box
      # texture : Raylib::Texture2d, text : String, x : Int32, y : Int32, clear_background : Bool = true
      player_name = FindingMaya.user_text_input_window(
        texture: @background,
        text: "Enter Your Name:",
        x: (SCREEN_WIDTH / 2).to_i,
        y: (SCREEN_HEIGHT / 2).to_i
      )

      player = Player.new(player_name)

      options = ["Agility", "Strength", "Intelligence", "Charisma", "Done"]
      selected = 0
      loop do
        return if Raylib.key_pressed?(Raylib::KeyboardKey::Escape)

        Raylib.begin_drawing
        Raylib.clear_background(Raylib::WHITE)
        Raylib.draw_texture(@background, 0, 0, Raylib::WHITE)

        # Display instructions
        Raylib.draw_text("Allocate Points", 300, 100, 40, Raylib::WHITE)
        Raylib.draw_text("Name: #{player.name}", 300, 150, 20, Raylib::WHITE)
        # Display available stat points
        Raylib.draw_text("Points Remaining: #{points_to_allocate}", 300, 200, 20, Raylib::WHITE)

        # Display stat points and values
        # Color the selected option red
        options.each_with_index do |option, index|
          # show the value of the stat using the player.#{stat} method unless it's done
          if index == selected
            unless option == "Done"
              Raylib.draw_text("#{option}: #{player.send(option.downcase)}", 300, 250 + (index * 50), 20, Raylib::RED)
            else
              Raylib.draw_text("#{option}", 300, 250 + (index * 50), 20, Raylib::RED)
            end
          else
            unless option == "Done"
              Raylib.draw_text("#{option}: #{player.send(option.downcase)}", 300, 250 + (index * 50), 20, Raylib::WHITE)
            else
              Raylib.draw_text("#{option}", 300, 250 + (index * 50), 20, Raylib::WHITE)
            end
          end
        end

        # Allow player to allocate points
        if Raylib.key_pressed?(Raylib::KeyboardKey::Down) && selected < (options.size - 1)
          selected += 1
        elsif Raylib.key_pressed?(Raylib::KeyboardKey::Up) && selected > 0
          selected -= 1
        elsif Raylib.key_pressed?(Raylib::KeyboardKey::Right) && points_to_allocate > 0
          # Add a point to the chosen option
          case selected
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
        elsif Raylib.key_pressed?(Raylib::KeyboardKey::Left)
          # Remove a point from the chosen option
          case selected
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

        # Break the loop if selected is on done and points_to_allocate is 0 and the enter key is pressed
        if Raylib.key_pressed?(Raylib::KeyboardKey::Enter) && selected == 4 && points_to_allocate == 0
          break
        end
        Raylib.end_drawing
      end
      @scene = Scene::LEVEL1
      @player = player
    end

    def level1
      return unless player = @player
      # Here we will handle the first level, the Level class exists in level.cr and expects the following:
      #   getter name : String
      # getter description : String
      # property x : Int32
      # property y : Int32
      # getter? collusion : Bool

      # # Set the texture for the entity
      # @texture : Raylib::Texture2D

      # def initialize(@name, @description, @x, @y, @texture, @collusion = true)
      # end
      test = Table.new(
        name: "Table",
        description: "A table, Nothing special about it, it's a bit dirty, maybe you should clean it",
        x: 500,
        y: 500,
        texture: Raylib.load_texture("assets/images/table.png"),
        collusion: true
      )

      enteties = Array(Entity).new
      enteties << test

      level = Level.new(
        background: Raylib.load_texture("assets/images/level1.png"),
        player: player,
        entities: enteties
      )
      level.play
    end

    def stop
      Raylib.unload_texture(@background)
      Raylib.close_window
    end
  end
end

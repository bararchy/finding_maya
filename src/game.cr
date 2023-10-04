require "./entity.cr"
require "./entity/*"
require "./player.cr"
require "./level.cr"

module FindingMaya
  class Game
    # Menu Constants
    BACKGROUND_IMAGE = Path["assets", "images", "big_background.png"].to_native.to_s
    OPTIONS          = ["New Game", "Exit"]

    enum Scene
      MAIN_MENU
      CHAR_CREATION
      INTRO
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
        when Scene::INTRO
          intro
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
      @scene = Scene::INTRO
      @player = player
    end

    def intro
      return unless player = @player
      # Here we handle the intro, this will be a cutscene, where Maya will talk via the commlink
      # with the player, then the player will be able to move to the first level.

      # First, we need to clean the screen and set it to black, the player right now is
      # waking up in a dark room, so we need to set the background to black
      # Maya's talking will be just text, so we need to create a text box
      waking_up = <<-EOF
        You wake up in a dark room, you can't see anything, you feel a bit dizzy,
        you try to remember what happened, but you can't, you don't remember anything.
        Suddenly a static noise from somewhere, like an old speaker coming to life *ZZZ*
        and you hear a woman's voice speaking to you
        EOF

      maya_dialog_1 = <<-EOF
        ???: Hello #{player.name}, this is your conscience speaking…
        #{player.name}: What's going on?
        ???: Do you remember that one time, when you did that really, really, excruciatingly embarrassing thing?
        #{player.name}: What?!
        ???: Yeah, you know the one… The one where you–
        #{player.name}: No!!!!
        ???: Oh, fine!  You were more fun when you were sleeping.
        #{player.name}: Sleeping?
        ???: Uh, yeah, bestie, you’ve been out for like, a month or something.
        #{player.name}: A month?!
        ???: Okay, maybe it was more like 72 hours, but it felt like a month. I lowkey thought you’d never wake up, to be honest.
        EOF

      maya_dialog_2 = <<-EOF
        ???: Yeah, I was like, getting pretty nervous, actually.
        ???: But you’re up now!  So we can get started.
        ???: Oh, and you can like.. Stop talking.  I can’t hear anything you’re saying anyway.
        ???: Y’know, because I’m a speaker.  Now, let’s get you out of here.
        EOF

      maya_dialog_end = <<-EOF
        ???: First task! Find a way out of this room.  There’s three options.
        ???: One!  Use your big brain and that computer to your left to figure out a way to bypass that digital lock on the door.
        ???: Two, you can snatch up that handy dandy IV pole and just bust a bitch open.
        ???: Or! Three, you can climb up into that nifty little air vent across from your bed and hope you come out the other side.
        ???: So?  What’ll it be?
        EOF

      texts = [waking_up, maya_dialog_1, maya_dialog_2]
      texts.each do |text|
        loop do
          Raylib.begin_drawing
          Raylib.clear_background(Raylib::BLACK)
          last_index = 0
          text.each_line.with_index do |line, index|
            if line.starts_with?("#{player.name}")
              Raylib.draw_text(line, 0, 0 + (index * 20), 20, Raylib::RED)
            elsif line.starts_with?("???")
              Raylib.draw_text(line, 0, 0 + (index * 20), 20, Raylib::GREEN)
            else
              Raylib.draw_text(line, 0, 0 + (index * 20), 20, Raylib::WHITE)
            end
            last_index = index
          end
          # print the (Press Enter to continue)
          Raylib.draw_text("(Press Enter to continue)", 0, 0 + (last_index * 40), 20, Raylib::WHITE)
          Raylib.end_drawing
          break if Raylib.key_pressed?(Raylib::KeyboardKey::Enter)
        end
      end

      @scene = Scene::LEVEL1
    end

    def level1
      return unless player = @player
      # Here we handle the first level, we will make a few entities and then pass them to the level class
      # Table is a class that inherits from Entity
      test = Table.new(
        name: "Table",
        description: "A table, Nothing special about it, it's a bit dirty, maybe you should clean it",
        x: 700,
        y: 700,
        texture: Raylib.load_texture(Path["assets", "images", "table.png"].to_native.to_s),
        collision: true
      )

      enteties = Array(Entity).new
      enteties << test

      level = Level.new(
        background: Raylib.load_texture(Path["assets", "images", "level1.png"].to_native.to_s),
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

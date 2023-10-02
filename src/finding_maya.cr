require "raylib-cr"
require "raylib-cr/raygui"

require "./constants.cr"
require "./helpers/*"
require "./game.cr"

module FindingMaya
  VERSION = "0.1.0"

  game = FindingMaya::Game.new

  game.run
end

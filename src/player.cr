require "./inventory.cr"

module FindingMaya
  class Player
    # main information
    getter name : String

    # stats
    property agility : Int32 = 0
    property strength : Int32 = 0
    property intelligence : Int32 = 0
    property charisma : Int32 = 0

    # inventory
    getter inventory : Inventory = Inventory.new

    # cash
    property cash : Int32 = 0

    def initialize(@name : String)
    end
  end
end

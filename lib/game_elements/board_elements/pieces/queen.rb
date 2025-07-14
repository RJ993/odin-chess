require_relative '../../players'
require_relative '../../movement'
require_relative '../../special_movements/restrictions'

class Queen
  attr_accessor :location, :color, :move_pos
  include Movement
  include Restrict

  def initialize(player)
    @color = player.color
    @display = make_display
    @moves = [[1, 1], [-1, -1], [-1, 1], [1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]]
    @move_pos = []
    @location = nil
  end

  def make_display
    possible_displays = {'white' => "\u2655 ", 'black' => "\u265B "}
    possible_displays[@color]
  end

  def to_s
    @display
  end
end
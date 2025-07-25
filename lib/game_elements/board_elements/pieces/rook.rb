require_relative '../../players'
require_relative '../../general_movement/movement'
require_relative '../../general_movement/restrictions'

class Rook
  attr_accessor :location, :color, :moved, :move_pos

  include Movement
  include Restrict

  def initialize(player)
    @color = player.color
    @display = make_display
    @moves = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    @move_pos = []
    @location = nil
    @moved = false
  end

  def make_display
    possible_displays = { 'white' => "\u2656 ", 'black' => "\u265C " }
    possible_displays[@color]
  end

  def to_s
    @display
  end
end

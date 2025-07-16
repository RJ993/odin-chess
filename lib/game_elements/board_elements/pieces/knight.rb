require_relative '../../players'
require_relative '../../general_movement/restrictions'
require_relative '../../general_movement/movement'

class Knight
  attr_accessor :location, :color, :move_pos
  include Movement
  include Restrict
  
  def initialize(player)
    @color = player.color
    @display = make_display
    @moves = [[1, 2], [-1, 2], [-1, -2], [1, -2], [2, -1], [2, 1], [-2, 1], [-2, -1]]
    @move_pos = []
    @location = nil
  end

  def make_display
    possible_displays = {'white' => "\u2658 ", 'black' => "\u265E "}
    possible_displays[@color]
  end

  def to_s
    @display
  end
end
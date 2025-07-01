require_relative '../../players'
require_relative '../../movement'

class Knight
  attr_accessor :location, :color
  include Movement
  def initialize(player)
    @color = player.color
    @display = make_display
    @moves = [[1, 2], [-1, 2], [-1, -2], [1, -2], [2, -1], [2, 1], [-2, 1], [-2, -1]]
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
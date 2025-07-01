require_relative '../../players'
require_relative '../../movement'

class Queen
  attr_accessor :location, :color
  include Movement

  def initialize(player)
    @color = player.color
    @display = make_display
    @moves = [[1, 1], [-1, 1], [-1, -1], [1, -1], [1, 0], [0, 1], [-1, 0], [0, -1]]
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
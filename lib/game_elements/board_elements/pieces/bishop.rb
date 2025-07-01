require_relative '../../players'
require_relative '../../movement'

class Bishop
  attr_accessor :location, :color
  include Movement

  def initialize(player)
    @color = player.color
    @display = make_display
    @moves = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
    @location = nil
  end

  def make_display
    possible_displays = {'white' => "\u2657 ", 'black' => "\u265D "}
    possible_displays[@color]
  end

  def to_s
    @display
  end
end
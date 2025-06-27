require_relative '../../players'

class Pawn
  attr_accessor :location

  def initialize
    @color = 'black'
    @display = make_display
    @location = nil
  end

  def make_display
    possible_displays = {'white' => "\u2659 ", 'black' => "\u265F "}
    possible_displays[@color]
  end

  def to_s
    @display
  end
end
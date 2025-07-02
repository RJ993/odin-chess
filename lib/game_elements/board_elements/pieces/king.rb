require_relative '../../players'
require_relative '../../movement'
require_relative '../../board'
require_relative '../squares'
require_relative '../../special_movements/castling'

class King
  attr_accessor :location, :color, :moves, :moved
  include Movement
  include Castling

  def initialize(player)
    @color = player.color
    @display = make_display
    @moves = generate_movement
    @location = nil
    @moved = false
  end

  def make_display
    possible_displays = {'white' => "\u2654 ", 'black' => "\u265A "}
    possible_displays[@color]
  end

  def to_s
    @display
  end

  def generate_movement(board = '')
    @moves = [[1, 1], [-1, 1], [-1, -1], [1, -1], [1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end
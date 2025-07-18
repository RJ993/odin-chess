require_relative '../../players'
require_relative '../../general_movement/movement'
require_relative '../../board'
require_relative '../squares'
require_relative '../../special_movements/castling'
require_relative '../../general_movement/restrictions'

class King
  attr_accessor :location, :color, :moves, :moved, :move_pos, :in_check, :blocked_squares, :fail_safe

  include Movement
  include Castling
  include Restrict

  def initialize(player)
    @color = player.color
    @display = make_display
    @moves = [[1, 1], [-1, -1], [-1, 1], [1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]]
    @move_pos = []
    @blocked_squares = []
    @fail_safe = []
    @location = nil
    @moved = false
    @in_check = false
  end

  def make_display
    possible_displays = { 'white' => "\u2654 ", 'black' => "\u265A " }
    possible_displays[@color]
  end

  def to_s
    @display
  end
end

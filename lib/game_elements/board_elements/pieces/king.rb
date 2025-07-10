require_relative '../../players'
require_relative '../../movement'
require_relative '../../board'
require_relative '../squares'
require_relative '../../special_movements/castling'

class King
  attr_accessor :location, :color, :moves, :moved, :move_pos, :in_check
  include Movement
  include Castling

  def initialize(player)
    @color = player.color
    @display = make_display
    @moves = [[1, 1], [-1, -1], [-1, 1], [1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]]
    @move_pos = []
    @location = nil
    @moved = false
    @in_check = false
  end

  def make_display
    possible_displays = {'white' => "\u2654 ", 'black' => "\u265A "}
    possible_displays[@color]
  end

  def to_s
    @display
  end

  def restrict_movement(opposing_player)
    enemy_squares = []
    opposing_player.pieces.each do |piece|
      enemy_squares.push(piece.move_pos)
    end
    forbidden_squares = enemy_squares.flatten.uniq
    move_pos.each do |possibility|
      move_pos.delete(possibility) if forbidden_squares.include?(possibility)
      forbidden_squares.include?(@location) ? @in_check = true : @in_check = false
    end
  end
end
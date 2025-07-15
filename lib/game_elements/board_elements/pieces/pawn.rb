require_relative '../../players'
require_relative '../../movement'
require_relative '../../board'
require_relative '../squares'
require_relative '../../special_movements/en_passant'
require_relative '../../special_movements/restrictions'

class Pawn
  attr_accessor :location, :color, :first_move, :moves, :en_passant_able, :move_pos
  include Movement
  include En_Passant
  include Restrict

  def initialize(player)
    @color = player.color
    @display = make_display
    @location = nil
    @moves = generate_movement
    @move_pos = []
    @first_move = true
    @en_passant_able = false
  end

  def make_display
    possible_displays = {'white' => "\u2659 ", 'black' => "\u265F "}
    possible_displays[@color]
  end

  def to_s
    @display
  end

  def generate_movement(board = '')
      current_location = board.layout.index {|square| square.designation == self.location} if board != ''
      array = []
    if color == 'white'
      array += [[0, 1]]
      if board != ''
      array += [[0, 2]] if @first_move == true && board.layout[current_location - 8].piece == nil
      array += [[1, 1]] if board.layout[current_location - 7].piece != nil
      array += [[-1, 1]] if board.layout[current_location - 9].piece != nil
      end
    else
      array += [[0, -1]]
      if board != ''
      array += [[0, -2]] if @first_move == true && board.layout[current_location + 8].piece == nil
      array += [[1, -1]] if board.layout[current_location + 9].piece != nil
      array += [[-1, -1]] if board.layout[current_location + 7].piece != nil
      end
    end
    array += en_passant?(board, current_location) if board != ''
    return array
  end

  def promote(player, new_square)
    puts 'What piece do you want to promote to'
    puts 'Q for Queen, R for Rook, B for Bishop, N for Knight'
    input = gets.chomp.upcase
    until %w[Q R B N].include?(input)
      puts 'Invalid. Please choose a piece'
    end
    case input
      when 'Q'
      player.pieces.push(Queen.new(player))
      when 'R'
      player.pieces.push(Rook.new(player))
      when 'B'
      player.pieces.push(Bishop.new(player))
      when 'N'
      player.pieces.push(Knight.new(player))
    end
    new_square.change_piece(player.pieces.last)
    player.pieces.delete(self)
  end

  def pawn_options(board, cord)
    front_squares = []
    self.move_pos.each do |square| 
      front_squares.push(square) if square[0] == cord[0]
    end
    front_squares.each do |square|
      actual_square = board.layout.find {|psquare| psquare.designation == square}
      self.move_pos.delete(square) if actual_square.piece != nil
    end
  end

  def pawn_conditions(player)
    player.pieces.each do |piece|
      self.en_passant_able = false if piece.class == Pawn && self.first_move == false
    end
    self.en_passant_able = true if self.first_move == true
    self.first_move = false if self.first_move == true
  end

  def pawn_methods(player, opposing_player, board, new_square, current_square_index, input, taken_piece = [])
    en_passant_met?(player, opposing_player, board, new_square, current_square_index, taken_piece) if new_square.piece == nil
    promote(player, new_square) if (player.color == 'white' && input[1] == '8') || (player.color == 'black' && input[1] == '1')
    pawn_conditions(player)
  end
end
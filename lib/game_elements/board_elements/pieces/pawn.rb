require_relative '../../players'
require_relative '../../movement'
require_relative '../../board'
require_relative '../squares'
require_relative '../../special_movements/en_passant'

class Pawn
  attr_accessor :location, :color, :first_move, :moves, :en_passant_able
  include Movement
  include En_Passant

  def initialize(player)
    @color = player.color
    @display = make_display
    @location = nil
    @moves = generate_movement
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

  def pawn_options(new_square, cord, player)
    return if new_square == nil
    player.pieces.each do |piece|
      self.en_passant_able = false if piece.class == Pawn && self.first_move == false
    end
    self.en_passant_able = true if self.first_move == true
    self.first_move = false if self.first_move == true
    new_square = nil if new_square.designation[0] == cord[0] && new_square.piece != nil
    new_square
  end
end
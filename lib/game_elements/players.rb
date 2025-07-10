require_relative 'board_elements/pieces/king'
require_relative 'board_elements/pieces/queen'
require_relative 'board_elements/pieces/rook'
require_relative 'board_elements/pieces/bishop'
require_relative 'board_elements/pieces/knight'
require_relative 'board_elements/pieces/pawn'
require_relative 'movement'

class Player
  attr_accessor :pieces, :color, :king

  def initialize(color, name = 'Mayonnaise')
    @name = name
    @color = color
    @king = King.new(self)
    @pieces = [Rook.new(self), Knight.new(self), Bishop.new(self), Queen.new(self), @king, Bishop.new(self), 
    Knight.new(self), Rook.new(self), Pawn.new(self), Pawn.new(self), Pawn.new(self), Pawn.new(self), Pawn.new(self),
    Pawn.new(self), Pawn.new(self), Pawn.new(self)]
    @winner = false
  end

  def determine_piece(input)
    self.pieces.find{|piece| piece.location == input}
  end

  def make_move(input, board, opposing_player)
    the_piece = determine_piece(input)
    until the_piece != nil
      puts 'There are no pieces on that square!'
      input = gets.chomp.downcase
      the_piece = determine_piece(input)
    end
    puts 'Where will you move your piece?'
    the_move = gets.chomp.downcase
    finished_move = the_piece.move(self, opposing_player, board, the_move)
    return finished_move
  end

  def prep_movement(board, opposing_player)
    pieces.each do |piece|
      piece.prep_move_pos(board, opposing_player)
    end
  end

  def in_check?
    if king.in_check == true
      puts "#{@name}, you are in check!!!"
    end
  end

  
  def out_of_check?(current_square, new_square, taken, taken_piece, opposing_player, board, moved_piece)
    square = new_square
    opposing_player.prep_movement(board, self)
    prep_movement(board, opposing_player)
    if king.in_check == true
      square = king.reset_movement(current_square, new_square, taken, taken_piece, opposing_player, moved_piece)
      puts 'Sorry, but that does not save you!'
    end
    square
  end
end
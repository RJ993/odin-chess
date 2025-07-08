require_relative 'board_elements/pieces/king'
require_relative 'board_elements/pieces/queen'
require_relative 'board_elements/pieces/rook'
require_relative 'board_elements/pieces/bishop'
require_relative 'board_elements/pieces/knight'
require_relative 'board_elements/pieces/pawn'
require_relative 'movement'

class Player
  attr_accessor :pieces, :color

  def initialize(color, name = 'Mayonnaise')
    @name = name
    @color = color
    @pieces = [Rook.new(self), Knight.new(self), Bishop.new(self), Queen.new(self), King.new(self), Bishop.new(self), 
    Knight.new(self), Rook.new(self), Pawn.new(self), Pawn.new(self), Pawn.new(self), Pawn.new(self), Pawn.new(self),
    Pawn.new(self), Pawn.new(self), Pawn.new(self)]
    @winner = false
  end

  def determine_piece(input)
    self.pieces.find{|piece| piece.location == input}
  end

  def make_move(input, board, game)
    the_piece = determine_piece(input)
    until the_piece != nil
      puts 'There are no pieces on that square!'
      input = gets.chomp.downcase
      the_piece = determine_piece(input)
    end
    puts 'Where will you move your piece?'
    the_move = gets.chomp.downcase
    #finished_move = the_piece.move(self, the_move, board, game)
    finished_move = the_piece.move(self, game, board, the_move)
    return finished_move
  end

  def prep_movement(board)
    pieces.each do |piece|
      piece.prep_move_pos(board)
    end
  end
end
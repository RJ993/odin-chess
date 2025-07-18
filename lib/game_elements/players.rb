require_relative 'board_elements/pieces/king'
require_relative 'board_elements/pieces/queen'
require_relative 'board_elements/pieces/rook'
require_relative 'board_elements/pieces/bishop'
require_relative 'board_elements/pieces/knight'
require_relative 'board_elements/pieces/pawn'
require_relative 'general_movement/movement'
require_relative 'general_movement/check'

class Player
  attr_accessor :pieces, :color, :king, :name, :winner, :draw

  include Check

  def initialize(color, name = 'Mayonnaise')
    @color = color
    @name = name
    @king = King.new(self)
    @pieces = [Rook.new(self), Knight.new(self), Bishop.new(self), Queen.new(self), @king, Bishop.new(self),
               Knight.new(self), Rook.new(self), Pawn.new(self), Pawn.new(self), Pawn.new(self), Pawn.new(self), Pawn.new(self),
               Pawn.new(self), Pawn.new(self), Pawn.new(self)]
    @winner = false
    @draw = false
  end

  def determine_piece(input)
    pieces.find { |piece| piece.location == input }
  end

  def make_move(input, board, opposing_player)
    the_piece = determine_piece(input)
    while the_piece.nil?
      puts 'There are no pieces on that square!'
      input = gets.chomp.downcase
      the_piece = determine_piece(input)
    end
    puts 'Where will you move your piece?'
    the_move = gets.chomp.downcase
    the_piece.move(self, opposing_player, board, the_move)
  end
end

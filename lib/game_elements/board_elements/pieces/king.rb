require_relative '../../players'
require_relative '../../movement'
require_relative '../../board'
require_relative '../squares'

class King
  attr_accessor :location, :color, :moves, :moved
  include Movement

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

  def short_castling(board, king_square, rook_square)
    if self.color == 'white'
      square_one = board.layout.find {|square| square.designation == 'f1'}
      square_two = board.layout.find {|square| square.designation == 'g1'}
      if square_one.piece == nil && square_two.piece == nil
        square_two.change_piece(self)
        square_one.change_piece(rook_square.piece)
        king_square.reset_square
        rook_square.reset_square
      end
    else
      square_one = board.layout.find {|square| square.designation == 'f8'}
      square_two = board.layout.find {|square| square.designation == 'g8'}
      if square_one.piece == nil && square_two.piece == nil
        square_two.change_piece(self)
        square_one.change_piece(rook_square.piece)
        king_square.reset_square
        rook_square.reset_square
      end
    end
  end

  def long_castling(board, king_square, rook_square)
    if self.color == 'white'
      square_one = board.layout.find {|square| square.designation == 'd1'}
      square_two = board.layout.find {|square| square.designation == 'c1'}
      square_three = board.layout.find {|square| square.designation == 'b1'}
      if square_one.piece == nil && square_two.piece == nil && square_three.piece == nil
        square_two.change_piece(self)
        square_one.change_piece(rook_square.piece)
        king_square.reset_square
        rook_square.reset_square
      end
    else
      square_one = board.layout.find {|square| square.designation == 'd8'}
      square_two = board.layout.find {|square| square.designation == 'c8'}
      square_three = board.layout.find {|square| square.designation == 'b8'}
      if square_one.piece == nil && square_two.piece == nil && square_three.piece == nil
        square_two.change_piece(self)
        square_one.change_piece(rook_square.piece)
        king_square.reset_square
        rook_square.reset_square
      end
    end
  end
end
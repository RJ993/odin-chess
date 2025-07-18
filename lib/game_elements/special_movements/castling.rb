require_relative '../board'
require_relative '../board_elements/squares'

module Castling
  def castling_manager(input, board, king_square, rook_square)
    king_square.piece.moved = true
    rook_square.piece.moved = true
    new_square = short_castling(board, king_square, rook_square) if input == 'o-o'
    new_square = long_castling(board, king_square, rook_square) if input == 'o-o-o'
    new_square
  end

  def castling?(input, board)
    king_square = board.layout.find { |square| square.designation == location }
    rook_square = find_rook_square(input, board)
    new_square = nil
    if king_square.piece.class != King || rook_square.piece.class != Rook || king_square.piece.in_check == true
      return new_square
    end

    if king_square.piece.moved == false && rook_square.piece.moved == false
      new_square = castling_manager(input, board, king_square, rook_square)
    end
    new_square
  end

  def find_rook_square(input, board)
    rook_square = board.layout.find { |square| square.designation == 'a1' } if color == 'white' && input == 'o-o-o'
    rook_square = board.layout.find { |square| square.designation == 'a8' } if color == 'black' && input == 'o-o-o'
    rook_square = board.layout.find { |square| square.designation == 'h1' } if color == 'white' && input == 'o-o'
    rook_square = board.layout.find { |square| square.designation == 'h8' } if color == 'black' && input == 'o-o'
    rook_square
  end

  def short_castling(board, king_square, rook_square)
    if color == 'white'
      if blocked_squares.include?('f1') == false
        square_one = board.layout.find do |square|
          square.designation == 'f1'
        end
      end
      if blocked_squares.include?('g1') == false
        square_two = board.layout.find do |square|
          square.designation == 'g1'
        end
      end
      new_square = act_of_castling(king_square, rook_square, square_one, square_two)
    else
      if blocked_squares.include?('f8') == false
        square_one = board.layout.find do |square|
          square.designation == 'f8'
        end
      end
      if blocked_squares.include?('g8') == false
        square_two = board.layout.find do |square|
          square.designation == 'g8'
        end
      end
      new_square = act_of_castling(king_square, rook_square, square_one, square_two)
    end
    new_square
  end

  def long_castling(board, king_square, rook_square)
    if color == 'white'
      if blocked_squares.include?('d1') == false
        square_one = board.layout.find do |square|
          square.designation == 'd1'
        end
      end
      if blocked_squares.include?('c1') == false
        square_two = board.layout.find do |square|
          square.designation == 'c1'
        end
      end
      square_three = board.layout.find { |square| square.designation == 'b1' }
      new_square = act_of_castling(king_square, rook_square, square_one, square_two, square_three)
    else
      if blocked_squares.include?('d8') == false
        square_one = board.layout.find do |square|
          square.designation == 'd8'
        end
      end
      if blocked_squares.include?('c8') == false
        square_two = board.layout.find do |square|
          square.designation == 'c8'
        end
      end
      square_three = board.layout.find { |square| square.designation == 'b8' }
      act_of_castling(king_square, rook_square, square_one, square_two, square_three)
      new_square = act_of_castling
    end
    new_square
  end

  def act_of_castling(king_square, rook_square, square_one, square_two, square_three = Square.new('', 'white'))
    return if square_one.nil? || square_two.nil? || square_three.nil?

    if square_one.piece.nil? && square_two.piece.nil? && square_three.piece.nil?
      square_two.change_piece(self)
      square_one.change_piece(rook_square.piece)
      king_square.reset_square
      rook_square.reset_square
      new_square = 'CASTLED'
    end
    new_square
  end
end

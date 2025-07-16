require_relative '../players'
require_relative '../board'
require_relative '../board_elements/squares'
require_relative '../../game_mechanics'

module Movement

  def move(player, opposing_player, board, input)
    new_square = self.castling?(input, board) if (input == 'o-o' || input == 'o-o-o') && self.class == King
    return new_square if new_square == 'CASTLED'
    self.moved == true if self.class == King || self.class == Rook
    current_square = board.layout.find{|square| square.designation == @location}
    current_square_index = board.layout.index{|square| square.designation == @location}
    new_square = board.layout.find{|square| square.designation == input} if self.move_pos.include?(input)
      if new_square != nil && new_square.piece == nil
        new_square.change_piece(self)
        current_square.reset_square
        pawn_methods(player, opposing_player, board, new_square, current_square_index, input) if self.class == Pawn
      elsif new_square != nil && new_square.piece.color != player.color
        pawn_methods(player, opposing_player, board, new_square, current_square_index, input) if self.class == Pawn
        takes(player, opposing_player, current_square, new_square)
      else
        puts 'Invalid square. Please try another square!'
      end
      new_square
  end
  
  def takes(taking_player, opposing_player, current_square, new_square, taken_piece = [])
    taken_piece.push(new_square.piece)
    opposing_player.pieces.delete(new_square.piece)
    new_square.change_piece(self)
    current_square.reset_square
  end

  def reset_movement(current_square, new_square, taken, taken_piece, opposing_player, moved_piece)
    if taken == true
      opposing_player.pieces.push(taken_piece[0])
      new_square.change_piece(taken_piece[0])
    else
      new_square.reset_square
    end
    current_square.change_piece(moved_piece)
    square = nil
    return square
  end
end
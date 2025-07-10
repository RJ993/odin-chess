require_relative '../board'
require_relative '../board_elements/squares'
require_relative '../players'
require_relative '../../game_mechanics'

module En_Passant
  def en_passant(taking_player, opposing_player, passed_square)
    opposing_player.pieces.delete(passed_square.piece)
    passed_square.reset_square
  end

  def en_passant_met?(player, opposing_player, board, new_square, current_square_index)
    if new_square != nil && board.layout[current_square_index - 1].piece.class == Pawn
      passing_square = board.layout[current_square_index - 1]
      en_passant(player, opposing_player, passing_square) if passing_square.piece.en_passant_able == true
    elsif new_square != nil && board.layout[current_square_index + 1].piece.class == Pawn
      passing_square = board.layout[current_square_index + 1]
      en_passant(player, opposing_player, passing_square) if passing_square.piece.en_passant_able == true
    end
  end

  def en_passant?(board, loc)
    array = []
    if color == 'white'
      if board.layout[loc].designation[1] == '5'
      array += [[1, 1]] if board.layout[loc + 1].piece.class == Pawn && board.layout[loc + 1].piece.color == 'black'
      array += [[-1, 1]] if board.layout[loc - 1].piece.class == Pawn && board.layout[loc + 1].piece.color == 'black'
      end
    else
      if board.layout[loc].designation[1] == '4'
      array += [[1, -1]] if board.layout[loc + 1].piece.class == Pawn && board.layout[loc + 1].piece.color == 'white'
      array += [[-1, -1]] if board.layout[loc - 1].piece.class == Pawn && board.layout[loc + 1].piece.color == 'white'
      end
    end
    return array
  end
end
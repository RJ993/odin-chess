require_relative 'players'
require_relative 'board'
require_relative 'board_elements/squares'
require_relative '../game_mechanics'

module Movement
  def move(player, input, board, game)
    new_square = self.castling?(input, board) if (input == 'o-o' || input == 'o-o-o') && self.class == King
    return new_square if new_square == 'CASTLED'
    current_square = board.layout.find{|square| square.designation == @location}
    current_square_index = board.layout.index{|square| square.designation == @location}
    current_square_location = current_square.designation
    cords = current_square_location.split('')
    alpha_number = board.alpha_to_number(cords[0])
    new_cords = [alpha_number, cords[1].to_i]
    new_square = determine_new_square(input, board, new_cords, cords, player)
    determine_move(new_square, current_square, player, game, board, current_square_index, input)
    new_square
  end

  def static_movement(input, board, new_cords)
    self.moves = self.generate_movement(board) if self.class == Pawn || self.class == King
    new_square = nil
    @moves.each do |possibility|
      new_let = board.number_to_alpha(possibility[0] + new_cords[0])
      new_num = possibility[1] + new_cords[1]
      if %w[a b c d e f g h].include?(new_let) && [1, 2, 3, 4, 5, 6, 7, 8].include?(new_num)
      new_cord = new_let + new_num.to_s
      new_square = board.layout.find {|square| square.designation == new_cord} if new_cord == input
      end
    end
    new_square
  end

  def dynamic_movement(input, board, new_cords)
    new_square = nil
    direction_multiplier = 1
    blocked = false
    @moves.each do |possibility|
      7.times do
        if blocked == false
          new_let = board.number_to_alpha((possibility[0]*direction_multiplier) + new_cords[0])
          new_num = (possibility[1]*direction_multiplier) + new_cords[1]
          if %w[a b c d e f g h].include?(new_let) && [1, 2, 3, 4, 5, 6, 7, 8].include?(new_num)
          new_cord = new_let + new_num.to_s
          direction_multiplier += 1
          pos = board.layout.find {|square| square.designation == new_cord}
          blocked = true if pos.piece != nil
          new_square = board.layout.find {|square| square.designation == new_cord} if new_cord == input
          end
        end
      end
    direction_multiplier = 1
    blocked = false
    end
    new_square
  end

  def takes(taking_player, game, current_square, new_square)
    if taking_player == game.white_player
      game.black_player.pieces.delete(new_square.piece)
    else
      game.white_player.pieces.delete(new_square.piece)
    end
    new_square.change_piece(self)
    current_square.reset_square
  end

  def determine_move(new_square, current_square, player, game, board, current_square_index, input)
    if new_square != nil && new_square.piece == nil
      new_square.change_piece(self)
      current_square.reset_square
      if self.class == Pawn
        self.en_passant_met?(player, game, board, new_square, current_square_index)
        self.promote(player, new_square) if (player.color == 'white' && input[1] == '8') || (player.color == 'black' && input[1] == '1')
      end
    elsif new_square != nil && new_square.piece.color != player.color
      takes(player, game, current_square, new_square)
    else
      puts 'Invalid square. Please try another square!'
    end
  end

  def determine_new_square(input, board, new_cords, cords, player)
    new_square = static_movement(input, board, new_cords) if self.class == King || self.class == Pawn || self.class == Knight
    new_square = dynamic_movement(input, board, new_cords) if self.class == Queen || self.class == Rook || self.class == Bishop
    new_square = self.pawn_options(new_square, cords, player) if self.class == Pawn
    new_square
  end
end
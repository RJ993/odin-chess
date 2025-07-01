require_relative 'players'
require_relative 'board'
require_relative 'board_elements/squares'
require_relative '../game_mechanics'

module Movement
  def move(player, input, board, game)
    current_square = board.layout.find{|square| square.designation == @location}
    current_square_index = board.layout.index{|square| square.designation == @location}
    current_square_location = current_square.designation
    cords = current_square_location.split('')
    alpha_number = board.alpha_to_number(cords[0])
    new_cords = [alpha_number, cords[1].to_i]
    new_square = static_movement(input, board, new_cords) if self.class == King || self.class == Pawn || self.class == Knight
    new_square = dynamic_movement(input, board, new_cords) if self.class == Queen || self.class == Rook || self.class == Bishop
    new_square = pawn_options(new_square, cords, player) if self.class == Pawn
    if new_square != nil && new_square.piece == nil
      new_square.change_piece(self)
      current_square.reset_square
      if self.class == Pawn
        en_passant_met?(player, game, board, new_square, current_square_index)
        self.promote(player, new_square) if (player.color == 'white' && input[1] == '8') || (player.color == 'black' && input[1] == '1')
      end
    elsif new_square != nil && new_square.piece.color != player.color
      takes(player, game, current_square, new_square)
    else
      puts 'Invalid square. Please try another square!'
    end
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
    @moves.each do |possibility|
      7.times do
        new_let = board.number_to_alpha((possibility[0]*direction_multiplier) + new_cords[0])
        new_num = (possibility[1]*direction_multiplier) + new_cords[1]
        if %w[a b c d e f g h].include?(new_let) && [1, 2, 3, 4, 5, 6, 7, 8].include?(new_num)
        new_cord = new_let + new_num.to_s
        direction_multiplier += 1
        new_square = board.layout.find {|square| square.designation == new_cord} if new_cord == input
        end
      end
    direction_multiplier = 1
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

  def en_passant(taking_player, game, passed_square)
    if taking_player == game.white_player
      game.black_player.pieces.delete(passed_square.piece)
    else
      game.white_player.pieces.delete(passed_square.piece)
    end
    passed_square.reset_square
  end

  def en_passant_met?(player, game, board, new_square, current_square_index)
    if new_square != nil && board.layout[current_square_index - 1].piece.class == Pawn
      passing_square = board.layout[current_square_index - 1]
      en_passant(player, game, passing_square) if passing_square.piece.en_passant_able == true
    elsif new_square != nil && board.layout[current_square_index + 1].piece.class == Pawn
      passing_square = board.layout[current_square_index + 1]
      en_passant(player, game, passing_square) if passing_square.piece.en_passant_able == true
    end
  end
end